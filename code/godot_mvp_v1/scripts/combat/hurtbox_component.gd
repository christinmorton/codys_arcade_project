extends Area2D
class_name HurtboxComponent

signal hit_received(damage: float)

func receive_hit(damage: float) -> void:
	hit_received.emit(damage)
	var parent := get_parent()
	while parent:
		for child in parent.get_children():
			if child is HealthComponent:
				child.take_damage(damage)
				return
		if parent is CharacterBody2D or parent is StaticBody2D:
			break
		parent = parent.get_parent()
