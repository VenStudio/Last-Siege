extends Button

enum Functionality {LOAD, EXIT, LOAD_MAINMENU, SETTINGS_INGAME}

@export var functionality = Functionality.LOAD
@export var load_scene = preload("res://Scenes/arrow.tscn")
@export var unload_scenes : Array[NodePath]
@export var time_scale : float = 1

var game_manager : Node

func _ready():
	game_manager = get_tree().get_root().get_node("Game")

func _on_pressed():
	Engine.time_scale = time_scale
	
	match functionality:
		Functionality.LOAD:
			if load_scene != null:
				game_manager.load_scene(load_scene, time_scale)
			if unload_scenes.size() > 0:
				for node in unload_scenes:
					game_manager.unload_scene(get_node(node))
		Functionality.EXIT:
			game_manager.close_game()
		Functionality.LOAD_MAINMENU:
			game_manager.load_main_menu(time_scale)
			
			if unload_scenes.size() > 0:
				for node in unload_scenes:
					game_manager.unload_scene(get_node(node))
		Functionality.SETTINGS_INGAME:
			if load_scene != null:
				var instance = game_manager.load_scene(load_scene, time_scale)
				instance.position = Vector2(-131, 25)
			if unload_scenes.size() > 0:
				for node in unload_scenes:
					game_manager.unload_scene(get_node(node))

