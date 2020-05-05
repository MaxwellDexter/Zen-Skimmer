extends Sprite

export (float) var return_time
var tween

func _ready():
	tween = get_node("Tween")

func return_to_zero():
	var tau = 6.283185
	
	# setting it back to zero
	var rots = rotation / tau
	var floored_rotation = float(int(rots)) * tau
	var scaled_rot = rotation - floored_rotation
	set_rotation(scaled_rot)
	
	# choose which way to turn
	rots = rotation / tau
	var desired_radians
	if rots > 1 or rots < -1:
		print("oh shit my guy, rotations for the player sprite was greater than one! was: ", rots)
	if rots > 0.5 or rots < -0.5:
		desired_radians = tau
	else:
		desired_radians = 0
	
	# tween there
	tween.interpolate_property(self, "rotation", rotation, desired_radians, return_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
