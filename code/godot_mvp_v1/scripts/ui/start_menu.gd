extends Control

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	start_button.pressed.connect(_on_start)
	quit_button.pressed.connect(_on_quit)
	start_button.grab_focus()

func _on_start() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")

func _on_quit() -> void:
	get_tree().quit()
