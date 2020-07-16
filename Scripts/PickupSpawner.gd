extends Node2D

onready var pickup_node = preload("res://Nodes/Pickup.tscn")
var total_diameter
var shape_sides
var current_pickups
var max_pickups
var stream
var sound_scale
signal pickups_gone_signal
export (float) var min_ambience_volume
export (float) var max_ambience_volume

var pickup_radius = 40
var collision
var pickup_holder

func _ready():
	current_pickups = 0
	collision = get_node("CollisionChecker")
	pickup_holder = get_node("PickupHolder")

func _on_Level_Loader_level_start(diameter, sides):
	total_diameter = diameter
	shape_sides = sides

func set_audio(the_stream, the_scale):
	stream = the_stream
	sound_scale = the_scale

func _on_Wall_Spawner_polygon_created(polygon_pool):
	if shape_sides > 6:
		spawn_circle(total_diameter)
	else:
		spawn_culled_square(total_diameter, polygon_pool)
	max_pickups = current_pickups

func spawn_culled_square(spawn_diameter, polygon_pool):
	var top_left_x = -spawn_diameter/2
	var pos = Vector2(top_left_x, top_left_x)
	
	var buffer = 0
	var space_between_pickups = pickup_radius * 2 + buffer
	var pickups_per_row = spawn_diameter / space_between_pickups
	
	var pickup_num = pickups_per_row + 1
	
	for i in range(pickup_num):
		if i != 0:
			pos.x = top_left_x
			pos.y += space_between_pickups
		for j in range(pickup_num):
			if collision.is_inside(polygon_pool, pos.x, pos.y, pickup_radius):
				spawn_pickup(pos)
			# do maths
			pos.x += space_between_pickups

func spawn_circle(spawn_diameter):
	var radius_large = spawn_diameter / 2
	var rc = radius_large - pickup_radius
	do_circle_spawn(rc, null)

func spawn_culled_circle(spawn_diameter, polygon_pool):
	var radius_large = spawn_diameter / 2
	var rc = radius_large - pickup_radius
	do_circle_spawn(rc, polygon_pool)

func do_circle_spawn(rc, polygon_pool):
	# yoinked from # https://www.engineeringtoolbox.com/smaller-circles-in-larger-circle-d_1849.html
	var no = floor((2 * PI * rc) / (2 * pickup_radius))
	if (no <= 0):
		return
	var x0 = rc * cos(0 * 2 * PI / no)
	var y0 = rc * sin(0 * 2 * PI / no)
	var x1 = rc * cos(1 * 2 * PI / no)
	var y1 = rc * sin(1 * 2 * PI / no)
	var dist = pow((pow((x0 - x1), 2) + pow((y0 - y1), 2)), 0.5)
	if dist < 2 * pickup_radius:
		no = no - 1
	
	for i in range(no):
		var x = rc * cos(i * 2 * PI / no)
		var y = rc * sin(i * 2 * PI / no)
		if (polygon_pool == null || (polygon_pool != null && collision.is_inside(polygon_pool, x, y, pickup_radius))):
			spawn_pickup(Vector2(x, y))
	
	var rcNext = rc - (2 * pickup_radius);
	if (rcNext >= pickup_radius):
		do_circle_spawn(rcNext, polygon_pool);

func spawn_pickup(pos):
	var pickup = pickup_node.instance()
	pickup_holder.add_child(pickup)
	pickup.prime_pickup(pos, stream, sound_scale)
	current_pickups += 1

func pickup_deleted(the_pickup):
	current_pickups -= 1
	if current_pickups < 1:
		emit_signal("pickups_gone_signal")
	else:
		inform_pickups()

func inform_pickups():
	var percentage = float(current_pickups) / float(max_pickups)
	# using the max as an offset to get the corrent percentage
	var volume = (min_ambience_volume - max_ambience_volume) * percentage + max_ambience_volume
	
	for child in pickup_holder.get_children():
		child.update_ambience(volume)


