extends Camera2D

var player

var max_zoom
var min_zoom

export (float) var zoom_speed_regular
export (float) var zoom_speed_trackpad

func _ready():
	InputManager.connect("pinch", self, "pinching")
	player = get_parent().get_node("Player")
	adjust_zoom_boundaries(get_viewport().size)

func _process(delta):
	set_position(player.get_position())

func pinching(event):
	# position, distance, relative, speed
	zoom_camera(event.relative * zoom_speed_regular)

func _input(event):
	if event is InputEventPanGesture:
		print(event.delta.y)
		zoom_camera(event.delta.y * zoom_speed_trackpad)

func zoom_camera(amount):
	zoom += Vector2(amount, amount)
	
	# snap it back
	if zoom.x > max_zoom:
		zoom = Vector2(max_zoom, max_zoom)
	if zoom.x < min_zoom:
		zoom = Vector2(min_zoom, min_zoom)

func adjust_zoom_boundaries(screen_size):
	var tiniest_max_zoom = 1.5
	var tiniest_min_zoom = 0.8
	var biggest_max_zoom = 1.3
	var biggest_min_zoom = 0.5

	var largest_screen = 2000
	var smallest_screen = 300
	
	var percentage = (screen_size.x - smallest_screen) / (largest_screen - smallest_screen)
	
	var to_remove_max = (tiniest_max_zoom - biggest_max_zoom) * percentage
	var to_remove_min = (tiniest_min_zoom - biggest_min_zoom) * percentage
	
	max_zoom = tiniest_max_zoom - to_remove_max
	min_zoom = tiniest_min_zoom - to_remove_min
