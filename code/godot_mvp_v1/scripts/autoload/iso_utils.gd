extends Node

## Converts a cartesian direction (e.g. WASD input) to isometric screen direction.
## Uses a 2:1 isometric ratio.
func cartesian_to_iso(cartesian: Vector2) -> Vector2:
	return Vector2(
		cartesian.x - cartesian.y,
		(cartesian.x + cartesian.y) * 0.5
	)

## Converts an isometric screen position back to cartesian coordinates.
func iso_to_cartesian(iso: Vector2) -> Vector2:
	return Vector2(
		iso.x * 0.5 + iso.y,
		-iso.x * 0.5 + iso.y
	)
