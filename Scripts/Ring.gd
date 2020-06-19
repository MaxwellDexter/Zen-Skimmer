extends Sprite

var tween
export (float) var delay_time

func _ready():
	set_material(get_material().duplicate())
	tween = get_node("Tween")
	tween.interpolate_property(get_material(), "shader_param/outer_r", 0, 0.5, delay_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(get_material(), "shader_param/inner_r", -0.1, 0.5, delay_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func _process(delta):
	if not tween.is_active():
		print('goodbye cruel world!')
		queue_free()
		print(is_queued_for_deletion())

func set_pos(pos):
	position = pos
