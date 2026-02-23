extends PickupBase

func _draw() -> void:
	# Blue square
	draw_rect(Rect2(-10, -10, 20, 20), Color(0.2, 0.3, 0.9))
	# Inner lighter square
	draw_rect(Rect2(-5, -5, 10, 10), Color(0.4, 0.5, 1.0))

func _apply_effect(player: Node2D) -> void:
	player.apply_buff("defense", 0.5, 10.0)
