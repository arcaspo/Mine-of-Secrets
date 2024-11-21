extends Node2D

@onready var destructible_polygon_2d: DestructiblePolygon2D = $DestructiblePolygon2D

static func generate_capsule_polygon(end_points: int, radius: float, height: float) -> PackedVector2Array:
	var polygon: = PackedVector2Array()
	
	var i_divisor: = float(end_points - 1)
	for i in end_points:
		polygon.append((radius * Vector2.from_angle((float(i) / i_divisor) * PI)) + Vector2(0, height / 2))
		#polygon.append(polar2cartesian(radius, (float(i) / i_divisor) * PI) + Vector2(0, height / 2))
	for i in end_points:
		#polygon.append(-polar2cartesian(radius, (float(i) / i_divisor) * PI) + Vector2(0, -height / 2))
		polygon.append(-(radius * Vector2.from_angle((float(i) / i_divisor) * PI)) + Vector2(0, -height / 2))
	
	return polygon

func create_polygon_array(location: Vector2, width, height, rot: float) -> PackedVector2Array:
	var polygon := PackedVector2Array()
	polygon = generate_capsule_polygon(9, width/2, height)
	
	#var t1 := Transform2D(0.0, Vector2(0, 30))
	#var t2 := Transform2D(rot, Vector2(0, -30))
	#var t3 := Transform2D(0.0, Vector2(-location.x+100, -location.y))
	#var t4 := t1 * t2 * t3
	var t := Transform2D()
	
	t.origin = Vector2(-location.x, -location.y + 23)
	var t2 := t.rotated(rot + 3.14)
	var t3 := Transform2D(0, Vector2(0, 50))
	var t4 := t3 * t2
	
	polygon *= t4
	return polygon

func mine(location, width, height, rot):
	var array := create_polygon_array(location, width, height, rot)
	destructible_polygon_2d.destruct(array)
