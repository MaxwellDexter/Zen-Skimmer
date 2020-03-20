extends Area2D

func _on_Pickup_body_entered(body):
	if body.get_name() == "Player":
		body.add_score()
	queue_free()