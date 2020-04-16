extends StaticBody2D

var col

func set_size(width, height):
	if col == null:
		col = get_node("CollisionShape2D")
	
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width, height)
	col.shape = shape