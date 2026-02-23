extends PickupBase

func _draw() -> void:
	# Gold circle
	draw_circle(Vector2.ZERO, 10.0, Color(1.0, 0.84, 0.0))
	# Inner darker circle for depth
	draw_circle(Vector2.ZERO, 5.0, Color(0.85, 0.65, 0.0))

func _apply_effect(_player: Node2D) -> void:
	GameManager.add_score(5)
