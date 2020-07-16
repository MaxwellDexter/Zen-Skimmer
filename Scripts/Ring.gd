extends Sprite

var tween
export (float) var delay_time

func _ready():
	set_material(get_material().duplicate())
	tween = get_node("Tween")
	var multiplier = rand_range(0.5, 1.5)
	tween.interpolate_property(get_material(), "shader_param/outer_r", 0, 0.5, delay_time * multiplier, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(get_material(), "shader_param/inner_r", -0.05, 0.5, delay_time * multiplier, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(get_material(), "shader_param/opacity", 1, 0.3, delay_time * multiplier, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _process(delta):
	if not tween.is_active():
		queue_free()

func set_pos(pos):
	position = pos
