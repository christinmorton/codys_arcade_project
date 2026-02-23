extends Node2D

## Distributes pickups across the playable area at runtime.

@export var coin_scene: PackedScene
@export var health_scene: PackedScene
@export var attack_powerup_scene: PackedScene
@export var defense_powerup_scene: PackedScene
@export var speed_powerup_scene: PackedScene

@export var coin_count: int = 15
@export var health_count: int = 5
@export var attack_count: int = 2
@export var defense_count: int = 2
@export var speed_count: int = 2

@export var bounds_min: Vector2 = Vector2(-1000, -240)
@export var bounds_max: Vector2 = Vector2(1000, 500)
@export var player_clear_radius: float = 150.0
@export var min_spacing: float = 60.0
@export var seed_value: int = 99

var _placed_positions: Array[Vector2] = []

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	_spawn_pickups(rng, coin_scene, coin_count)
	_spawn_pickups(rng, health_scene, health_count)
	_spawn_pickups(rng, attack_powerup_scene, attack_count)
	_spawn_pickups(rng, defense_powerup_scene, defense_count)
	_spawn_pickups(rng, speed_powerup_scene, speed_count)

func _spawn_pickups(rng: RandomNumberGenerator, scene: PackedScene, count: int) -> void:
	if scene == null:
		return
	var spawned := 0
	var attempts := 0
	while spawned < count and attempts < count * 20:
		attempts += 1
		var pos := Vector2(
			rng.randf_range(bounds_min.x, bounds_max.x),
			rng.randf_range(bounds_min.y, bounds_max.y)
		)

		# Keep a clear zone around player spawn (0,0)
		if pos.length() < player_clear_radius:
			continue

		# Ensure minimum spacing from other pickups
		var too_close := false
		for existing in _placed_positions:
			if pos.distance_to(existing) < min_spacing:
				too_close = true
				break
		if too_close:
			continue

		_placed_positions.append(pos)
		var pickup := scene.instantiate()
		pickup.position = pos
		add_child(pickup)
		spawned += 1
