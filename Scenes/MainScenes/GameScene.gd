extends Node2D

var map_node

var build_mode = false
var build_valid = false
var buikd_location
var build_type

func _ready():
	map_node = get_node("Map1")
	for button in get_tree().get_nodes_in_group("build_buttons"):
		button.connect("pressed", self, "initiate_build_mode", [button.get_name()])

func _process(delta):
	pass

func _unhandled_input(event):
	pass

func initiate_build_mode(tower_type):
	build_type = tower_type + "T1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	pass

func cancel_build_mode():
	pass

func verify_and_build():
	pass
