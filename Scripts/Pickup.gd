extends RigidBody2D

var audio
var sprite
onready var random_note = get_node("Randomiser")
var picked_up

func _ready():
	audio = get_node("Sound")
	sprite = get_node("Sprite")
	picked_up = false

func player_hit():
	sprite.hide()
	play_sound()

func _on_AudioStreamPlayer2D_finished():
	# sound is done
	var parent = get_parent()
	if parent.name == "Pickup Spawner":
		parent.pickup_deleted()
	queue_free()

func play_sound():
	audio.set_pitch_scale(random_note.get_random_note())
	audio.play()
