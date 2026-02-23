extends CanvasLayer

const PauseMenuScene := preload("res://scenes/ui/pause_menu.tscn")
const DeathScreenScene := preload("res://scenes/ui/death_screen.tscn")
const WinScreenScene := preload("res://scenes/ui/win_screen.tscn")

@onready var health_bar: Control = $MarginContainer/VBoxContainer/HealthBar
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var input_mode_label: Label = $MarginContainer/VBoxContainer/InputModeLabel
@onready var buff_container: HBoxContainer = $MarginContainer/VBoxContainer/BuffContainer
@onready var atk_label: Label = $MarginContainer/VBoxContainer/BuffContainer/AtkLabel
@onready var def_label: Label = $MarginContainer/VBoxContainer/BuffContainer/DefLabel
@onready var spd_label: Label = $MarginContainer/VBoxContainer/BuffContainer/SpdLabel

var _overlay_active: bool = false

func _ready() -> void:
	GameManager.player_died.connect(_on_player_died)
	GameManager.enemy_killed.connect(_on_enemy_killed)
	GameManager.game_won.connect(_on_game_won)
	GameManager.score_changed.connect(_on_score_changed)
	InputManager.input_mode_changed.connect(_on_input_mode_changed)
	_update_score()
	_update_input_mode_label()

	# Hide buff labels initially
	atk_label.visible = false
	def_label.visible = false
	spd_label.visible = false

	# Connect to player health and buff signals after scene is ready
	await get_tree().process_frame
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		if player.has_node("HealthComponent"):
			player.get_node("HealthComponent").health_changed.connect(health_bar.update_bar)
		if player.has_signal("buff_changed"):
			player.buff_changed.connect(_on_buff_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not _overlay_active:
		if not GameManager.is_game_over and not GameManager.is_won:
			_show_pause_menu()
			get_viewport().set_input_as_handled()

func _show_pause_menu() -> void:
	_overlay_active = true
	var pause_menu := PauseMenuScene.instantiate()
	pause_menu.tree_exited.connect(func(): _overlay_active = false)
	get_tree().current_scene.add_child(pause_menu)

func _on_player_died() -> void:
	if _overlay_active:
		return
	_overlay_active = true
	var death_screen := DeathScreenScene.instantiate()
	get_tree().current_scene.add_child(death_screen)

func _on_game_won() -> void:
	if _overlay_active:
		return
	_overlay_active = true
	var win_screen := WinScreenScene.instantiate()
	get_tree().current_scene.add_child(win_screen)

func _on_enemy_killed(_enemy: Node) -> void:
	_update_score()

func _on_score_changed(_new_score: int) -> void:
	_update_score()

func _update_score() -> void:
	score_label.text = "Score: %d" % GameManager.score

func _on_input_mode_changed(_mode) -> void:
	_update_input_mode_label()

func _update_input_mode_label() -> void:
	var mode_name := "WASD + Mouse" if InputManager.current_mode == InputManager.InputMode.WASD_MOUSE else "Point & Click"
	input_mode_label.text = "Input: %s (Tab to toggle)" % mode_name

func _on_buff_changed(buff_type: String, active: bool) -> void:
	match buff_type:
		"attack":
			atk_label.visible = active
		"defense":
			def_label.visible = active
		"speed":
			spd_label.visible = active
