extends RigidBody2D

export (int) var drag_speed
export (int) var hold_speed
export (int) var maximum_drag_force
export (int) var drag_speed_cutoff
export (float) var drag_release_time
var holding
var dragging
onready var timer = get_node("Timer")

func _ready():
	InputManager.connect("single_touch", self, "touch")
	InputManager.connect("single_drag", self, "drag")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	timer.set_one_shot(true)
	timer.set_wait_time(drag_release_time)
	timer.connect("timeout", self, "release_timeout")

func _input(event):
	if event.is_action_pressed("click"):
		start_holding()
	elif event.is_action_released("click"):
		stop_holding()
	
	if holding and event is InputEventMouseMotion:
		dragging = event.get_speed().length() > drag_speed_cutoff
		if dragging:
			var vel = event.get_speed() / maximum_drag_force
#			print("vel: ", event.get_speed().length())
	#		print("Mouse Motion at: ", vel)
			apply_central_impulse(vel * drag_speed)

func _process(delta):
	# print(linear_velocity)
	rotate(linear_velocity.length() * delta)

func _physics_process(delta):
	if holding and not dragging:
		# maybe store the viewport?
		# impulse towards mouse point
		var target = get_viewport().get_mouse_position()
		var dir = (target - get_transform().origin).normalized()
		apply_central_impulse(dir * hold_speed)
		
		# look at mouse
#		get_transform().get_origin().linear_interpolate(target,delta)
#		target.lerp(get_transform().origin, 1)
		# look_at(target)
		#rotate(linear_velocity.length())
		#print("holding!")
	else:
		pass
		#print("not!")

func start_holding():
	holding = true

func stop_holding():
	holding = false
	if dragging:
		timer.start()

func release_timeout():
	dragging = false
	# stop spinning

func touch(val):
	print('touching')
	print(val)

func drag(val):
	print('dragging')
	print(val)