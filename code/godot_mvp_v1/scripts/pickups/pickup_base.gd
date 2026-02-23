extends Area2D
class_name PickupBase

## Base class for all collectible pickups.
## Subclasses override _apply_effect() and _draw() for custom behavior.

var _bob_offset: float = 0.0
var _bob_speed: float = 2.5
var _bob_amplitude: float = 4.0
var _base_y: float = 0.0

func _ready() -> void:
	collision_layer = 64  # layer 7 (pickups)
	collision_mask = 1    # layer 1 (player)
	_base_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	_bob_offset += delta * _bob_speed
	position.y = _base_y + sin(_bob_offset) * _bob_amplitude

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_apply_effect(body)
		queue_free()

## Override in subclasses to define what happens when collected.
func _apply_effect(_player: Node2D) -> void:
	pass
