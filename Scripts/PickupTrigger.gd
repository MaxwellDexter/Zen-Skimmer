extends Area2D

var picked_up

func _ready():
	picked_up = false

func _on_Trigger_Area_body_entered(body):
	if body.get_name() == "Player" and not picked_up:
		body.add_score()
		picked_up = true
		get_parent().player_hit()
