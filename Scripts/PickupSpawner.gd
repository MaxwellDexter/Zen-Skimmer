extends Node2D

onready var pickup_node = preload("res://Nodes/Pickup.tscn")
var pickups_per_row
var current_pickups
var max_pickups
var stream
var sound_scale
signal pickups_gone_signal
export (float) var min_ambience_volume
export (float) var max_ambience_volume

func _ready():
	current_pickups = 0

func begin_level(diameter, pickups):
	pickups_per_row = pickups
	spawn_them_all(diameter)

func set_audio(the_stream, the_scale):
	stream = the_stream
	sound_scale = the_scale

func spawn_them_all(spawn_diameter):
	# resizing box to buffer
	var buffer = spawn_diameter * 0.05
	var top_left_x = -spawn_diameter/2 + buffer
	var pos = Vector2(top_left_x, top_left_x)
	
	spawn_diameter -= buffer*2
	var space_between_pickups = spawn_diameter / pickups_per_row
	
	var pickup_num = pickups_per_row + 1
	
	for i in range(pickup_num):
		if i != 0:
			pos.x = top_left_x
			pos.y += space_between_pickups
		for j in range(pickup_num):
			# make node
			var pickup = pickup_node.instance()
			add_child(pickup)
			pickup.prime_pickup(pos, stream, sound_scale)
			# do maths
			pos.x += space_between_pickups
			current_pickups += 1
	
	max_pickups = current_pickups

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
	
	for child in get_children():
		child.update_ambience(volume)
