extends Area2D

var pickup_audio
var ambient_audio
var sprite
var picked_up
var player
var speed_mod
export (float) var fly_speed
onready var random_note = get_node("Randomiser")

func _ready():
	picked_up = false
	pickup_audio = get_node("Pickup Sound")
	sprite = get_node("Sprite")
	speed_mod = randf() + 0.5 # between 0.5 and 1.5
	
	ambient_audio = get_node("Ambient Noise")
	var ambient_randomiser = get_node("RandomiserAmbient")
	ambient_audio.set_pitch_scale(ambient_randomiser.get_random_note())

func prime_pickup(pos, audio_stream, sound_scale):
	position = pos
	pickup_audio.stream = audio_stream
	random_note.scale_type = sound_scale

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
		parent.pickup_deleted(self)
	queue_free()

func play_sound():
	pickup_audio.set_pitch_scale(random_note.get_random_note())
	pickup_audio.play()
	
func start_flying_to_player(player_obj):
	player = player_obj

func _process(delta):
	fly_to_player(delta)

func fly_to_player(delta):
	if player == null:
		return
	var smoothed_velocity = (player.position - position) * fly_speed * delta * speed_mod
	position += smoothed_velocity

func update_ambience(volume):
	ambient_audio.set_volume_db(volume)
