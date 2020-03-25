extends Node2D

onready var pickup_node = preload("res://Nodes/Pickup.tscn")
export (int) var number_of_pickups
export (int) var spawn_radius
var current_pickups

func _ready():
	current_pickups = 0
	spawn_them_all()

func spawn_them_all():
	current_pickups += number_of_pickups
	for i in range(number_of_pickups):
		var pickup = pickup_node.instance()
		pickup.position = Vector2(rand_range(-spawn_radius, spawn_radius), rand_range(-spawn_radius, spawn_radius))
		add_child(pickup)

func pickup_deleted():
	current_pickups -= 1
	print(current_pickups)
	if current_pickups < 1:
		spawn_them_all()