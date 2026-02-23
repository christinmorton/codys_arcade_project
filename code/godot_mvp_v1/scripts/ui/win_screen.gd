extends CanvasLayer

@onready var overlay: ColorRect = $Overlay
@onready var score_label: Label = $Overlay/CenterContainer/PanelContainer/VBoxContainer/ScoreLabel
@onready var play_again_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/PlayAgainButton
@onready var menu_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Force overlay to fill the viewport
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	play_again_button.pressed.connect(_on_play_again)
	menu_button.pressed.connect(_on_main_menu)
	score_label.text = "Final Score: %d" % GameManager.score
	play_again_button.grab_focus()
	# Small delay so the boss death is visible
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = true

func _on_play_again() -> void:
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().reload_current_scene()

func _on_main_menu() -> void:
	GameManager.request_return_to_menu()
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")
