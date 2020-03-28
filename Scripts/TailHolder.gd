extends Node2D

var tails = []
onready var tail = preload("res://Nodes/Tail.tscn")
export (int) var offset
var player

# maybe apply impulse??

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	# totalscore / (points * pickup)
	var tail_points = int(player.total_score / (player.pickup_points * player.pickups_per_tail))
	if tails.size() < tail_points:
		add_tail()

func add_tail():
	var inst = tail.instance()
	tails.append(inst)
	inst.position = player.position
	inst.set_tail(player, offset * tails.size(), tails.size())
	add_child(inst)