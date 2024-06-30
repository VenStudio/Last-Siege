extends Node

@export var main_menu = preload("res://Scenes/main_menu.tscn")

func _ready():
	var instance = main_menu.instantiate()
	add_child(instance)
	TranslationServer.set_locale("en")

func load_scene(scene, time_scale = 1):
	var instance = scene.instantiate()
	$".".add_child(instance)
	Engine.time_scale = time_scale
	return instance

func load_main_menu(time_scale = 1):
	var instance = main_menu.instantiate()
	add_child(instance)
	Engine.time_scale = time_scale

func unload_scene(node):
	node.queue_free()

func close_game():
	get_tree().quit()

signal update_ui
func update():
	update_ui.emit()
	
