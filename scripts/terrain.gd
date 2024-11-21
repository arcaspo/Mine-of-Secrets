extends Node2D

@onready var ground: Polygon2D = $ground
@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

func _ready() -> void:
	collision_polygon.set_deferred("polygon", ground.polygon)
	
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

func _process(delta: float) -> void:
	# Mouse in viewport coordinates.
	if Input.is_action_just_pressed("click"):
		var array := create_polygon_array(get_viewport().get_mouse_position(), 5, 10, 90)
		clip(array)

func mine(location, width, height, rot):
	var array := create_polygon_array(location, width, height, rot)
	clip(array)

func create_polygons(polys: Array[PackedVector2Array]):
	var poly_array: PackedVector2Array
	ground.polygons.clear()
	for poly in polys:
		poly_array += poly
		
		var polys_array: Array
		for i in range(poly.size()):
			polys_array.append(i + (poly_array.size() - poly.size()))
		ground.polygons.append(polys_array)
	
	#print(ground.polygon)
	print(ground.polygons)
	ground.polygon = poly_array
	
	collision_polygon.set_deferred("polygon", poly_array)
	collision_polygon.set_deferred("polygons", ground.polygons)
	

func clip(poly: PackedVector2Array):
	var new_poly := Geometry2D.clip_polygons(ground.polygon, poly)
	var i = 0
	create_polygons(new_poly)
	#ground.polygons = new_poly
	#ground.polygon = new_poly[0]
	
