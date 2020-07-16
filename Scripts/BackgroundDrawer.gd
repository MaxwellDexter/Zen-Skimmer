extends Node2D

var polygon
var colour
var colours

var diameter
var shape_sides

export (int) var number_of_shadows
export (float) var expansion_rate
export (float) var line_thickness

func _draw():
	if polygon != null and colour != null:
		draw_shape_with_shadows(polygon, number_of_shadows, shape_sides > 10)

func draw_shape_with_shadows(pool, shadow_amount, is_circle):
	var percentage = 1.0 / shadow_amount
	var opacity = 1
	var shape = pool
	var current_radius = diameter / 2
	
	for i in range(shadow_amount):
		var current_colour = colour
		current_colour.a = opacity
		
		if is_circle:
			draw_empty_circle(Vector2(), Vector2(0, current_radius), current_colour, .1)
			current_radius *= expansion_rate
		else:
			draw_connected_shape(shape, current_colour)
			shape = expand_shape(shape, expansion_rate)
		
		opacity -= percentage

# from https://www.reddit.com/r/godot/comments/3ktq39/drawing_empty_circles_and_curves/
func draw_empty_circle(circle_center, circle_radius, color, resolution):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center
	
	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color, line_thickness)
		draw_counter += 1 / resolution
		line_origin = line_end
	
	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color, line_thickness)

func draw_connected_shape(pool, the_colour):
	for i in range(pool.size()):
		var point = pool[i]
		var next
		if i == pool.size() - 1:
			next = pool[0]
		else: next = pool[i+1]
		draw_line(point, next, the_colour, line_thickness, true)

func expand_shape(pool, amount):
	for i in pool.size():
		pool[i] = pool[i] * amount
	return pool

func _on_Level_Loader_level_start(total_diameter, sides):
	diameter = total_diameter
	shape_sides = sides

func _on_Wall_Spawner_polygon_created(polygon_pool):
	polygon = polygon_pool
	update()

func _on_Level_Loader_colour_change(colour):
	self.colour = Color(colour)
	colours = PoolColorArray()
	for i in range(polygon.size()):
		colours.append(colour)
	update()
