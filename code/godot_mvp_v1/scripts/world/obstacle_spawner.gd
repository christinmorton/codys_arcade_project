extends Node2D

## Distributes obstacles across the playable area at runtime.

@export var obstacle_scene: PackedScene
@export var obstacle_count: int = 30
@export var bounds_min: Vector2 = Vector2(-1000, -240)
@export var bounds_max: Vector2 = Vector2(1000, 500)
@export var player_clear_radius: float = 120.0
@export var min_spacing: float = 80.0
@export var seed_value: int = 42

var _placed_positions: Array[Vector2] = []

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	var attempts := 0
	while _placed_positions.size() < obstacle_count and attempts < obstacle_count * 20:
		attempts += 1
		var pos := Vector2(
			rng.randf_range(bounds_min.x, bounds_max.x),
			rng.randf_range(bounds_min.y, bounds_max.y)
		)

		# Keep a clear zone around player spawn (0,0)
		if pos.length() < player_clear_radius:
			continue

		# Ensure minimum spacing between obstacles
		var too_close := false
		for existing in _placed_positions:
			if pos.distance_to(existing) < min_spacing:
				too_close = true
				break
		if too_close:
			continue

		_placed_positions.append(pos)
		var obstacle := obstacle_scene.instantiate()
		obstacle.position = pos
		add_child(obstacle)
