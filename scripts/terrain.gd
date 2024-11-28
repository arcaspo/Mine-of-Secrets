extends Node2D

@onready var destructible_polygon_2d: DestructiblePolygon2D = $DestructiblePolygon2D
@export var terrain_setup: TerrainSetup

func _ready() -> void:
	setup_terrain(terrain_setup)
	generate_ores()

func setup_terrain(terrain_setup: TerrainSetup):
	for layer in terrain_setup.TerrainLayers:
		var polygon2d := Polygon2D.new()
		var y = layer.start
		
		var depth = layer.depth
		polygon2d.polygon = PackedVector2Array([
			Vector2(0, y), 
			Vector2(terrain_setup.Width, y), 
			Vector2(terrain_setup.Width, depth),
			Vector2(0, depth)
		])
		polygon2d.texture = layer.texture
		polygon2d.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		destructible_polygon_2d.add_child(polygon2d)
		destructible_polygon_2d.update_bounds_and_area(polygon2d, polygon2d.polygon)
		destructible_polygon_2d.add_collision_polygon(polygon2d)

func generate_capsule_polygon(end_points: int, radius: float, height: float) -> PackedVector2Array:
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
	
	var t1 := Transform2D(0.0, Vector2(-location.x, -location.y - height/2))
	var t2 := Transform2D(0.0, Vector2(0, height/2 + 23))
	var t3 := Transform2D(rot, Vector2(0, -height/2 - 23))
	#var t3 := Transform2D(0.0, Vector2(location.x + height/2, location.y))
	#var t3 := Transform2D(0.0, location)
	var t4 := t3 * t2 * t1
	#var t := Transform2D()
	# + height / 2
	#t.origin = Vector2(-location.x, -location.y)
	#var t2 := t.rotated(rot + 3.14)
	#print(t2.x)
	#var t3 = t2.translated(t2.x * height/2)
	#var t3 := Transform2D(0, Vector2(0, 0))
	#var t4 := t3 * t2
	
	polygon *= t4
	return polygon

func mine(location: Vector2, width: int, power: int, rot):
	var array: PackedVector2Array
	for layer in terrain_setup.TerrainLayers:
		if location.y >= layer.start and location.y <= layer.depth:
			array = create_polygon_array(location, width, power / layer.density, rot)
			break
	
	if array.size() == 0:
		array = create_polygon_array(location, width, power / terrain_setup.TerrainLayers[0].density, rot)
		
	destructible_polygon_2d.destruct(array)

func generate_ores():
	for layer in terrain_setup.TerrainLayers:
		for ore_rarity in layer.ores:
			for i in range(0, ore_rarity.Rarity):
				var ore := ore_rarity.Ore.instantiate()
				ore.transform = Transform2D(0.0, Vector2(randf_range(0, terrain_setup.Width), randf_range(layer.start, layer.depth)))
				add_child(ore)
