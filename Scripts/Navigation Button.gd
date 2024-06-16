extends Button

@export var pos = Vector2(0, 0)
@export var zoom = Vector2(1, 1)
@onready var camera_2d = %Camera2D
@onready var player = %Player

var old_pos = Vector2(0,0)
var old_zoom = Vector2(1, 1)

func _on_pressed():
	navigate()

func navigate():
	old_pos = camera_2d.position
	old_zoom = camera_2d.zoom
	
	camera_2d.position = pos
	camera_2d.zoom = zoom

func reset_navigation():
	camera_2d.position = old_pos
	camera_2d.zoom = old_zoom
