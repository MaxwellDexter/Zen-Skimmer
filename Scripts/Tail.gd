extends Node2D

const SMOOTH_SPEED = 10

var follow_node
var offset
var speed_multiplier

func set_tail(player_node, player_offset, index):
	follow_node = player_node
	offset = player_offset
	speed_multiplier = index

func _physics_process(delta):
	#var length = follow_node.linear_velocity.normalized().length()
	var forward = follow_node.global_transform.basis_xform(Vector2(-1,0))
	var pos = follow_node.position + forward * offset
	
	var position_difference = pos - position
	var smoothed_velocity = (position_difference * SMOOTH_SPEED * delta) / speed_multiplier
	
	position += smoothed_velocity