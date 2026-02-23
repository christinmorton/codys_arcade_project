extends Node2D

## Creates invisible collision walls around the playable area.

@export var bounds_min: Vector2 = Vector2(-1100, -300)
@export var bounds_max: Vector2 = Vector2(1100, 560)
@export var wall_thickness: float = 32.0

func _ready() -> void:
	_create_walls()

func _create_walls() -> void:
	var width := bounds_max.x - bounds_min.x
	var height := bounds_max.y - bounds_min.y
	var cx := (bounds_min.x + bounds_max.x) / 2.0
	var cy := (bounds_min.y + bounds_max.y) / 2.0

	# Top wall
	_add_wall(Vector2(cx, bounds_min.y - wall_thickness / 2.0), Vector2(width + wall_thickness * 2, wall_thickness))
	# Bottom wall
	_add_wall(Vector2(cx, bounds_max.y + wall_thickness / 2.0), Vector2(width + wall_thickness * 2, wall_thickness))
	# Left wall
	_add_wall(Vector2(bounds_min.x - wall_thickness / 2.0, cy), Vector2(wall_thickness, height + wall_thickness * 2))
	# Right wall
	_add_wall(Vector2(bounds_max.x + wall_thickness / 2.0, cy), Vector2(wall_thickness, height + wall_thickness * 2))

func _add_wall(pos: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = pos
	body.collision_layer = 4  # obstacles layer
	body.collision_mask = 0

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)

	add_child(body)
