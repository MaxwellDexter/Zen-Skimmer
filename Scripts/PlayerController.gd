extends KinematicBody2D

export (int) var speed = 200
var status = "none"

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('movement_horizontal'):
        velocity.x += 1
	velocity = velocity.normalized() * speed

func _input(ev):
	if status=="clicked" and ev.type == InputEvent.MOUSE_MOTION:
		status="dragging"
		
	if status=="dragging" and ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			status="released"
	
	print(ev.global_pos)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)