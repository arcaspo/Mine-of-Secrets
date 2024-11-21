extends Node2D

@onready var destructible_polygon_2d: DestructiblePolygon2D = $DestructiblePolygon2D

func create_polygon_array(location: Vector2, width, height, rot) -> PackedVector2Array:
	var polygon := PackedVector2Array()
	var x = location.x - width/2
	var y = location.y
	polygon = [
		Vector2(x, y),
		Vector2(x + width, y),
		Vector2(x + width, y + height),
		Vector2(x, location.y + height)
	]
	
	var t1 := Transform2D(0.0, Vector2(-location.x, -y))
	var t2 := Transform2D(rot, Vector2(location.x, y))
	var t3 := t2 * t1
	polygon *= t3
	return polygon

func mine(location, width, height, rot):
	var array := create_polygon_array(location, width, height, rot)
	destructible_polygon_2d.destruct(array)
