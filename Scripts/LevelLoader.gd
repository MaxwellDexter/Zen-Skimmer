extends Node2D

export (float) var diameter
onready var audio = preload("res://Audio/SFX_Pickup_3.5.wav")

func _ready():
	new_level()

func new_level():
	var children = get_children()
	for child in children:
		if (child.get_name() == "Pickup Spawner"):
			child.set_audio(audio, RNoteConsts.SCALE.Custom)
		child.begin_level(diameter)

func _on_Pickup_Spawner_pickups_gone_signal():
	new_level()
