extends CanvasLayer

@onready var overlay: ColorRect = $Overlay
@onready var resume_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/RestartButton
@onready var menu_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Force overlay to fill the viewport
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	resume_button.pressed.connect(_on_resume)
	restart_button.pressed.connect(_on_restart)
	menu_button.pressed.connect(_on_main_menu)
	resume_button.grab_focus()
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_resume()
		get_viewport().set_input_as_handled()

func _on_resume() -> void:
	get_tree().paused = false
	queue_free()

func _on_restart() -> void:
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().reload_current_scene()

func _on_main_menu() -> void:
	GameManager.request_return_to_menu()
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")
