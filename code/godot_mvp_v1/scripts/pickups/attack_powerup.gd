extends PickupBase

func _draw() -> void:
	# Red square
	draw_rect(Rect2(-10, -10, 20, 20), Color(0.9, 0.15, 0.15))
	# Inner lighter square
	draw_rect(Rect2(-5, -5, 10, 10), Color(1.0, 0.4, 0.4))

func _apply_effect(player: Node2D) -> void:
	player.apply_buff("attack", 2.0, 10.0)
