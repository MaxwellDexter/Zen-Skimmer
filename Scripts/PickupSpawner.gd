extends Node2D

onready var pickup_node = preload("res://Nodes/Pickup.tscn")
export (int) var space_between_pickups
export (int) var spawn_radius
var current_pickups

func _ready():
	current_pickups = 0
	spawn_them_all()

func spawn_them_all():
	var num_pickups = spawn_radius / space_between_pickups
	var pos = Vector2(-spawn_radius/2, -spawn_radius/2)
	for i in range(num_pickups):
		pos.x = -spawn_radius/2
		pos.y += space_between_pickups
		for j in range(num_pickups):
			# make node
			var pickup = pickup_node.instance()
			pickup.position = pos
			add_child(pickup)
			# do maths
			pos.x += space_between_pickups
			current_pickups += 1

func pickup_deleted():
	current_pickups -= 1
	print(current_pickups)
	if current_pickups < 1:
		spawn_them_all()