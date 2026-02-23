extends Node
class_name HealthComponent

signal health_changed(current_hp: float, max_hp: float)
signal health_depleted

@export var max_health: float = 100.0
var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	# Apply defense buff multiplier if parent has one
	var parent := get_parent()
	if parent and "damage_multiplier" in parent:
		amount *= parent.damage_multiplier
	current_health = max(0.0, current_health - amount)
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		health_depleted.emit()

func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)
