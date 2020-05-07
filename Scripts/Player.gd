extends RigidBody2D

export (int) var drag_speed
export (int) var hold_speed
export (int) var maximum_drag_force
export (float) var drag_force_minimum
export (float) var drag_release_time
export (float) var magnet_area_min
export (float) var magnet_area_max
export (float) var magnet_growth_rate
export (float) var maximum_speed
var dragging
var holding_pos
onready var timer_drag_release = get_node("Timer")
onready var sprite = get_node("Sprite")
onready var magnet_shape = get_node("Magnet Area/Magnet Shape")

# score stuff
export (int) var pickup_points
export (int) var pickups_per_tail
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
	if dragging:
		sprite.rotate((linear_velocity.x + linear_velocity.y) * delta * 0.05)
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
	if (event.speed.length() < drag_force_minimum
		or linear_velocity.length() > maximum_speed):
		return
	
	var normalised_speed = event.speed / maximum_drag_force
	apply_central_impulse(normalised_speed * drag_speed)
	
	dragging = true
	hold_this(event.position)
	var time = drag_release_time * normalised_speed.length()
	start_timer(time)

func hold_this(pos):
	holding_pos = pos

# signal method
func release_timeout():
	dragging = false
	sprite.return_to_zero()

func start_timer(time):
	timer_drag_release.set_wait_time(time)
	timer_drag_release.start()

func get_position_on_screen(pos):
	return camera.get_camera_screen_center() - viewport_size/2 + pos

func add_score():
	total_score += pickup_points
	calc_magnet_area()

func calc_magnet_area():
	var radius = clamp(total_score * magnet_growth_rate, magnet_area_min, magnet_area_max)
	magnet_shape.shape.radius = radius

func _on_Magnet_Area_area_entered(area):
	if "Pickup" in area.get_name():
		area.start_flying_to_player(self)
