extends Node

export var max_load_time = 10000

func _ready():
	var _ignore
	_ignore = get_node("MainMenu/M/VB/NewGame").connect("pressed", self, "on_new_game_pressed")
	_ignore = get_node("MainMenu/M/VB/Quit").connect("pressed", self, "on_quit_game_pressed")

func on_new_game_pressed():
	switch_scene("MainMenu","res://Scenes/MainScenes/GameScene.tscn")
	
	#remove MainMenu
	# get_node("MainMenu").queue_free()
	#load GameScene (which contains the map scene)
	# var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	#add it as a child node to this (SceneHandler) which will then redner it
	# add_child(game_scene)

func on_quit_game_pressed():
	get_tree().quit()





func switch_scene(current_scene_name, to_path_scene, pause_time = 0.001):
	var loading_bar = load("res://Scenes/UIScenes/LoadingScreen.tscn").instance()
	#get_tree().get_root().call_deferred('add_child',loading_bar)
	add_child(loading_bar)
	loading_bar.set_progress(0)
	var start_time = OS.get_ticks_msec()
	
	#Wait for load screen to load (not required, just looks a bit better)
	var t = Timer.new()
	t.set_wait_time(pause_time)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	var loader = ResourceLoader.load_interactive(to_path_scene)
	if loader == null:
		print("SceneHander.Resource Loader was unable to load the resourse.")
		return
	
	while OS.get_ticks_msec() - start_time < max_load_time:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			#Loading is Complete
			if current_scene_name != null:
				get_node(current_scene_name).queue_free()
			var new_scene = loader.get_resource().instance()
			#get_tree().get_root().call_deferred('add_child', new_scene)
			add_child(new_scene)
			loading_bar.queue_free()
			break
		elif err == OK:
			#Still loading
			var progress = float(loader.get_stage()) / (loader.get_stage_count()-1)
			loading_bar.set_progress(progress * 100)
			print(progress * 100)
		else:
			print("SceneHandler: Error while loading scene")
			loading_bar.queue_free()
			break
		
		yield(get_tree(),"idle_frame")
