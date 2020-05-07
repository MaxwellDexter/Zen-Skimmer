extends Node2D

var current_level
var player
var pickup_spawner
var wall_spawner

func _ready():
	current_level = 1
	player = get_parent().find_node("Player")
	pickup_spawner = get_child(0)
	wall_spawner = get_child(1)
	new_level()

func new_level():
	var level_data = load_level_from_file()
	
	pickup_spawner.set_audio(load_audio(level_data.sfx_pickup), RNoteConsts.SCALE.Custom)
	pickup_spawner.begin_level(level_data.diameter, level_data.pickups)
	
	wall_spawner.begin_level(level_data.diameter)
	
	reset_player(level_data.player_spawn.x, level_data.player_spawn.y)

func _on_Pickup_Spawner_pickups_gone_signal():
	current_level += 1
	new_level()

func reset_player(x, y):
	player.reset(Vector2(x, y))

func get_file_path(level_num):
	return "res://Levels/level_" + str(level_num) + ".json"

func load_level_from_file():
	var file = File.new()
	var path = get_file_path(current_level)
	if not file.file_exists(path):
		current_level = 1
		path = get_file_path(current_level)
	
	file.open(path, File.READ)
	var json = file.get_as_text()
	var result_json = JSON.parse(json)
	var result = {}
	
	if result_json.error == OK:  # If parse OK
		var data = result_json.result
		return data
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)

func load_audio(filename):
	return load("res://Audio/" + filename + ".wav")
