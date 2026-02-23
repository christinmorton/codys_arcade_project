extends PickupBase

func _draw() -> void:
	# Cyan square
	draw_rect(Rect2(-10, -10, 20, 20), Color(0.0, 0.85, 0.85))
	# Inner lighter square
	draw_rect(Rect2(-5, -5, 10, 10), Color(0.3, 1.0, 1.0))

func _apply_effect(player: Node2D) -> void:
	player.apply_buff("speed", 1.5, 10.0)
