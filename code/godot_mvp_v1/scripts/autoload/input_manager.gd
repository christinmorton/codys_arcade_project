extends Node

enum InputMode { WASD_MOUSE, POINT_AND_CLICK }

signal input_mode_changed(new_mode: InputMode)

var current_mode: InputMode = InputMode.WASD_MOUSE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_input_mode"):
		if current_mode == InputMode.WASD_MOUSE:
			current_mode = InputMode.POINT_AND_CLICK
		else:
			current_mode = InputMode.WASD_MOUSE
		input_mode_changed.emit(current_mode)
