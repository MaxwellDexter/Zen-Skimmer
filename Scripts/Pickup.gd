extends Area2D

var audio
var sprite
var picked_up

func _ready():
	picked_up = false
	audio = get_node("Sound")
	sprite = get_node("Sprite")

func _on_Pickup_body_entered(body):
	if body.get_name() == "Player" and not picked_up:
		body.add_score()
		sprite.hide()
		play_sound()
		picked_up = true

func _on_AudioStreamPlayer2D_finished():
	# sound is done
	var parent = get_parent()
	if parent.name == "Pickup Spawner":
		parent.pickup_deleted()
	queue_free()

func play_sound():
	audio.set_pitch_scale(rand_range(.5,1.5))
	audio.play()
	