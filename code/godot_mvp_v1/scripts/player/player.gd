extends CharacterBody2D

@export var speed: float = 200.0
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 0.4
@export var attack_reach: float = 52.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_pivot: Marker2D = $AttackPivot
@onready var health_component: HealthComponent = $HealthComponent

var _attack_timer: float = 0.0
var _click_target: Vector2 = Vector2.ZERO
var _has_click_target: bool = false
var _last_move_dir: Vector2 = Vector2.RIGHT
var _is_attacking: bool = false

# Buff system
var damage_multiplier: float = 1.0
var _base_speed: float
var _base_attack_damage: float
var _active_buffs: Dictionary = {}  # type -> { "multiplier": float, "timer": Timer }

signal buff_changed(buff_type: String, active: bool)

func _ready() -> void:
	add_to_group("player")
	health_component.health_depleted.connect(_on_death)
	_base_speed = speed
	_base_attack_damage = attack_damage

func _physics_process(delta: float) -> void:
	_attack_timer = max(0.0, _attack_timer - delta)

	var move_dir := Vector2.ZERO

	match InputManager.current_mode:
		InputManager.InputMode.WASD_MOUSE:
			move_dir = _get_wasd_movement()
			_aim_at_mouse()
			# Attack on left click — checked here to avoid UI input blocking
			if Input.is_action_just_pressed("attack"):
				_try_attack()
		InputManager.InputMode.POINT_AND_CLICK:
			move_dir = _get_click_movement()
			_aim_at_nearest_enemy()

	if move_dir != Vector2.ZERO:
		_last_move_dir = move_dir

	velocity = move_dir * speed
	move_and_slide()

	# Visual feedback: attack flash or buff tint
	if _is_attacking:
		sprite.modulate = Color(1.5, 1.5, 2.0, 1.0)
	elif _active_buffs.size() > 0:
		sprite.modulate = _get_buff_tint()
	else:
		sprite.modulate = Color.WHITE

func _get_wasd_movement() -> Vector2:
	var raw := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	if raw == Vector2.ZERO:
		return Vector2.ZERO
	var iso_dir := IsoUtils.cartesian_to_iso(raw.normalized())
	return iso_dir.normalized()

func _get_click_movement() -> Vector2:
	if not _has_click_target:
		return Vector2.ZERO
	var distance := global_position.distance_to(_click_target)
	if distance < 5.0:
		_has_click_target = false
		return Vector2.ZERO
	return global_position.direction_to(_click_target)

func _aim_at_mouse() -> void:
	var mouse_pos := get_global_mouse_position()
	attack_pivot.look_at(mouse_pos)

func _aim_at_nearest_enemy() -> void:
	var nearest: Node2D = null
	var nearest_dist := 999999.0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		var dist := global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
	if nearest and nearest_dist < 200.0:
		attack_pivot.look_at(nearest.global_position)
	elif _last_move_dir != Vector2.ZERO:
		attack_pivot.rotation = _last_move_dir.angle()

func _input(event: InputEvent) -> void:
	# Point & Click input — use _input to ensure it isn't blocked by UI
	if InputManager.current_mode == InputManager.InputMode.POINT_AND_CLICK:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				_click_target = get_global_mouse_position()
				_has_click_target = true
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				_try_attack()

func _try_attack() -> void:
	if _attack_timer > 0.0:
		return
	_attack_timer = attack_cooldown
	_is_attacking = true

	# Calculate attack point in front of player based on aim direction
	var attack_dir := Vector2.RIGHT.rotated(attack_pivot.rotation)
	var attack_pos := global_position + attack_dir * (attack_reach * 0.5)

	# Direct distance check against all enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		var dist := attack_pos.distance_to(enemy.global_position)
		if dist <= attack_reach:
			if enemy.has_node("HealthComponent"):
				enemy.get_node("HealthComponent").take_damage(attack_damage)

	await get_tree().create_timer(0.15).timeout
	_is_attacking = false

func apply_buff(type: String, multiplier: float, duration: float) -> void:
	# If same buff type is active, refresh the timer
	if _active_buffs.has(type):
		var existing_timer: Timer = _active_buffs[type]["timer"]
		existing_timer.stop()
		existing_timer.wait_time = duration
		existing_timer.start()
		_active_buffs[type]["multiplier"] = multiplier
	else:
		var timer := Timer.new()
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(_on_buff_expired.bind(type))
		add_child(timer)
		timer.start()
		_active_buffs[type] = { "multiplier": multiplier, "timer": timer }
		buff_changed.emit(type, true)

	_recalculate_stats()

func _on_buff_expired(type: String) -> void:
	if _active_buffs.has(type):
		var timer: Timer = _active_buffs[type]["timer"]
		timer.queue_free()
		_active_buffs.erase(type)
		buff_changed.emit(type, false)
		_recalculate_stats()

func _recalculate_stats() -> void:
	speed = _base_speed
	attack_damage = _base_attack_damage
	damage_multiplier = 1.0

	for type in _active_buffs:
		var mult: float = _active_buffs[type]["multiplier"]
		match type:
			"speed":
				speed = _base_speed * mult
			"attack":
				attack_damage = _base_attack_damage * mult
			"defense":
				damage_multiplier = mult

func _get_buff_tint() -> Color:
	var tint := Color(1.0, 1.0, 1.0, 1.0)
	if _active_buffs.has("attack"):
		tint.r = 1.4
		tint.g *= 0.85
		tint.b *= 0.85
	if _active_buffs.has("defense"):
		tint.r *= 0.85
		tint.g *= 0.85
		tint.b = 1.4
	if _active_buffs.has("speed"):
		tint.r *= 0.85
		tint.g = 1.3
		tint.b = 1.3
	return tint

func _on_death() -> void:
	GameManager.on_player_died()
	visible = false
	set_physics_process(false)
