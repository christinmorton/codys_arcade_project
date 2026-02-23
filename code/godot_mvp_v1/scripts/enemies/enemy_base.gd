extends CharacterBody2D
class_name EnemyBase

@export var speed: float = 80.0
@export var damage: float = 5.0
@export var attack_range: float = 30.0
@export var attack_cooldown: float = 1.0
@export var drop_chance: float = 0.3

const CoinPickupScene := preload("res://scenes/pickups/coin_pickup.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_zone: Area2D = $DetectionZone
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_component: HealthComponent = $HealthComponent

var _target: Node2D = null
var _attack_timer: float = 0.0

func _ready() -> void:
	add_to_group("enemies")
	detection_zone.body_entered.connect(_on_detection_body_entered)
	detection_zone.body_exited.connect(_on_detection_body_exited)
	health_component.health_depleted.connect(die)
	health_component.health_changed.connect(_on_health_changed)

func _physics_process(delta: float) -> void:
	_attack_timer = max(0.0, _attack_timer - delta)

	if _target == null or not is_instance_valid(_target):
		_target = null
		return

	var distance := global_position.distance_to(_target.global_position)

	if distance <= attack_range:
		_try_attack()
		velocity = Vector2.ZERO
	else:
		_chase_target()

	move_and_slide()

func _chase_target() -> void:
	nav_agent.target_position = _target.global_position
	if not nav_agent.is_navigation_finished():
		var next_pos := nav_agent.get_next_path_position()
		var direction := global_position.direction_to(next_pos)
		velocity = direction * speed

func _try_attack() -> void:
	if _attack_timer > 0.0:
		return
	_attack_timer = attack_cooldown
	if _target.has_node("HealthComponent"):
		_target.get_node("HealthComponent").take_damage(damage)

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_target = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null

func _on_health_changed(_current: float, _max: float) -> void:
	# Flash red when hit
	sprite.modulate = Color(3.0, 0.3, 0.3, 1.0)
	await get_tree().create_timer(0.12).timeout
	if is_instance_valid(self):
		sprite.modulate = Color.WHITE

func die() -> void:
	_try_drop_pickup()
	GameManager.on_enemy_killed(self)
	queue_free()

func _try_drop_pickup() -> void:
	if randf() <= drop_chance:
		var coin := CoinPickupScene.instantiate()
		coin.global_position = global_position
		# Add to Entities node (grandparent) for proper y-sorting
		get_parent().get_parent().add_child(coin)
