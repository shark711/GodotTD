extends Node

func _ready():
	get_node("MainMenu/M/VB/NewGame").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/M/VB/Quit").connect("pressed", self, "on_quit_game_pressed")

func on_new_game_pressed():
	#remove MainMenu
	get_node("MainMenu").queue_free()
	#load GameScene (which contains the map scene)
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	#add it as a child node to this (SceneHandler) which will then redner it
	add_child(game_scene)

func on_quit_game_pressed():
	get_tree().quit()
