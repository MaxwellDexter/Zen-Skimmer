extends Node2D

var collision_polygon
signal polygon_created(polygon_pool)

func _ready():
	collision_polygon = find_node("CollisionPolygon2D")

func _on_Level_Loader_level_start(diameter, sides):
	spawn_circle_walls(diameter, sides)

func spawn_circle_walls(diameter, sides):
	adjust_polygon(diameter, sides)

func adjust_polygon(diameter, n):
	var pool = PoolVector2Array()
	var theta = PI * 2 / n
	for k in range(0, n):
		var point = calculate_root_of_unity_point(theta, k)
		point *= diameter/2
		point = rotate_point_backwards(point)
		pool.append(point)
	collision_polygon.polygon = pool
	emit_signal("polygon_created", pool)

func calculate_root_of_unity_point(theta, k):
	# calculate the real and imaginary part of root 
	var real = cos(k * theta)
	var img = sin(k * theta)
	return Vector2(real, img)

func rotate_point_backwards(point):
	return Vector2(point.y, -point.x)
