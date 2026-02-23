extends PickupBase

func _draw() -> void:
	# Green circle
	draw_circle(Vector2.ZERO, 10.0, Color(0.2, 0.8, 0.2))
	# White cross
	var cross_size := 5.0
	var cross_width := 2.0
	draw_rect(Rect2(-cross_width / 2, -cross_size, cross_width, cross_size * 2), Color.WHITE)
	draw_rect(Rect2(-cross_size, -cross_width / 2, cross_size * 2, cross_width), Color.WHITE)

func _apply_effect(player: Node2D) -> void:
	if player.has_node("HealthComponent"):
		player.get_node("HealthComponent").heal(25.0)
