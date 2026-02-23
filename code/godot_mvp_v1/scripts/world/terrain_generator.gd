extends Node2D

## Generates a seamless isometric diamond tile floor at runtime.
## Tiles are placed to fully cover the area defined by bounds_min/bounds_max.

@export var tile_texture: Texture2D
@export var bounds_min: Vector2 = Vector2(-1080, -280)
@export var bounds_max: Vector2 = Vector2(1080, 540)

## Tile dimensions (must match the texture's diamond shape)
const TILE_WIDTH := 128.0
const TILE_HEIGHT := 64.0
const ROW_STEP := TILE_HEIGHT * 0.5  # 32px vertical spacing between rows

func _ready() -> void:
	_generate_floor()

func _generate_floor() -> void:
	# Add padding so tiles extend beyond the bounds (no edge gaps)
	var pad_x := TILE_WIDTH
	var pad_y := TILE_HEIGHT

	var start_x := bounds_min.x - pad_x
	var end_x := bounds_max.x + pad_x
	var start_y := bounds_min.y - pad_y
	var end_y := bounds_max.y + pad_y

	var row := 0
	var y := start_y
	while y <= end_y:
		var x := start_x
		# Offset odd rows by half a tile width
		if row % 2 == 1:
			x += TILE_WIDTH * 0.5

		while x <= end_x:
			var tile := Sprite2D.new()
			tile.texture = tile_texture
			tile.position = Vector2(x, y)
			add_child(tile)
			x += TILE_WIDTH

		y += ROW_STEP
		row += 1
