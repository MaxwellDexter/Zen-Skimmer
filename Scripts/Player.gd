extends RigidBody2D

export (int) var drag_speed
export (int) var hold_speed
export (int) var maximum_drag_force
export (float) var drag_release_time
var dragging
var holding_pos
onready var timer_drag_release = get_node("Timer")

func _ready():
	InputManager.connect("single_touch", self, "touch")
	InputManager.connect("single_drag", self, "drag")
	timer_drag_release.set_one_shot(true)
	timer_drag_release.set_wait_time(drag_release_time)
	timer_drag_release.connect("timeout", self, "release_timeout")

func _process(delta):
	# print(linear_velocity)
	rotate(linear_velocity.length() * delta)

func _physics_process(delta):
	if holding_pos != null and not dragging:
		var dir = (holding_pos - get_transform().origin).normalized()
		apply_central_impulse(dir * hold_speed)

func touch(event):
	if (event.pressed):
		hold_this(event.position)
	else:
		hold_this(null)

func drag(event):
	apply_central_impulse(event.speed / maximum_drag_force * drag_speed)
	dragging = true
	hold_this(event.position)
	timer_drag_release.start()

func hold_this(pos):
	holding_pos = pos

func release_timeout():
	dragging = false
	# stop spinning