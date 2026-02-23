extends Control

@onready var fill: ColorRect = $Fill

var _max_width: float = 0.0

func _ready() -> void:
	_max_width = fill.size.x

func update_bar(current: float, maximum: float) -> void:
	var ratio := current / maximum if maximum > 0.0 else 0.0
	fill.size.x = _max_width * ratio
