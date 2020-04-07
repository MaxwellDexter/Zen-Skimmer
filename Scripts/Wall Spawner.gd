extends Node2D

onready var wall_node = preload("res://Nodes/Wall.tscn")
export (float) var wall_thickness
var walls

func _ready():
	spawn_walls(2000, 2000)

func spawn_walls(width, height):
	width /= 2
	height /= 2
	spawn_wall(-width, 0, wall_thickness, height) # left
	spawn_wall(width, 0, wall_thickness, height) # right
	spawn_wall(0, -height, width, wall_thickness) # top
	spawn_wall(0, height, width, wall_thickness) # bottom

func spawn_wall(xpos, ypos, width, height):
	var wall = wall_node.instance()
	wall.position.x = xpos
	wall.position.y = ypos
	wall.set_size(width, height)
	add_child(wall)