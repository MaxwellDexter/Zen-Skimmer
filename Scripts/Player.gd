extends RigidBody2D

export (int) var drag_speed
export (int) var hold_speed
export (int) var maximum_drag_force
export (float) var drag_force_minimum
export (float) var drag_release_time
var dragging
var holding_pos
onready var timer_drag_release = get_node("Timer")

# score stuff
export (int) var pickup_points
var total_score

# camera stuff
var camera
var viewport_size

# notes
# what if when you pick up a certain amount of them
# you get a magnet power up so you can collect the rest of them easier

func _ready():
	InputManager.connect("single_touch", self, "touch")
	InputManager.connect("single_drag", self, "drag")
	timer_drag_release.set_one_shot(true)
	timer_drag_release.connect("timeout", self, "release_timeout")
	
	camera = get_parent().get_node("MainCamera")
	viewport_size = get_viewport().get_visible_rect().size
	
	total_score = 0

func _physics_process(delta):
	# rotation
	if (dragging):
		rotate(linear_velocity.length() * delta)
	else:
		look_at(get_transform().get_origin() + linear_velocity.normalized() * delta)
	
	# moving to touch
	if holding_pos != null and not dragging:
		var dir = (get_position_on_screen(holding_pos) - get_transform().origin).normalized()
		apply_central_impulse(dir * hold_speed)

# signal method
func touch(event):
	if (event.pressed):
		hold_this(event.position)
	else:
		hold_this(null)

# signal method
func drag(event):
	if (event.speed.length() < drag_force_minimum):
		return
	
	var normalised_speed = event.speed / maximum_drag_force
	apply_central_impulse(normalised_speed * drag_speed)
	
	dragging = true
	hold_this(event.position)
	start_timer(drag_release_time * normalised_speed.length())

func hold_this(pos):
	holding_pos = pos

# signal method
func release_timeout():
	dragging = false

func start_timer(time):
	timer_drag_release.set_wait_time(time)
	timer_drag_release.start()

func get_position_on_screen(pos):
	return camera.get_camera_screen_center() - viewport_size/2 + pos

func add_score():
	total_score += pickup_points
	print(total_score)