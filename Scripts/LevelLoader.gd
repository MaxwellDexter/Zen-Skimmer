extends Node2D

export (float) var diameter

func _ready():
	new_level()

func new_level():
	print('new level')
	var children = get_children()
	for child in children:
		child.begin_level(diameter)

func _on_Pickup_Spawner_pickups_gone_signal():
	new_level()
