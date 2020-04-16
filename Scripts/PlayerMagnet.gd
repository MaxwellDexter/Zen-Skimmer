extends Area2D

export (float) var gravity_scale

func _on_Magnet_body_entered(body):
	body.gravity_scale = gravity_scale
