extends AnimatableBody2D

var placed = false
@export var _spacing : int = 80
static var spaces_arr = [true]

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var shape_cast_2d = $ShapeCast2D
@onready var player : Node2D
@onready var trap_placed_audio = $"Trap Placed Audio"
@onready var trap_sold_audio = $"Trap Sold Audio"
@onready var trap_place_canceled_audio = $"Trap Place Canceled Audio"

var spaces : int = 13
var current_space :int = 0
var space : int = -1
var ground_level : int = 581
var navigation_button : Button
var price : int = 0
var economy_system : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if spaces_arr.size() == spaces:
		return
	
	for i in range(0, spaces - 1):
		spaces_arr.append(false)

func _input(event):
	
	if placed:
		return
	
	if player:
		player._can_shoot = false
	
	if event.is_action_pressed("escape"):
		if player:
			player._can_shoot = true
		
		trap_place_canceled_audio.play()
		queue_free()

	if current_space >= spaces:
		current_space = 0
	
	if spaces_arr[current_space]:
		animated_sprite_2d.modulate = Color("red")
	else:
		animated_sprite_2d.modulate = Color("green")
	
	if event is InputEventMouseMotion and event.position.x > 0:
		current_space = int((event.position.x - _spacing) / _spacing)
		global_position = Vector2(current_space * _spacing, ground_level)
	elif event is InputEventMouseMotion and event.position.x <= 0:
		global_position = Vector2(0 * _spacing, ground_level)
	elif event is InputEventMouseButton:
		if  not bool(spaces_arr[current_space]):
			place_trap(current_space)

func _unhandled_key_input(event):
	if event is InputEventMouseButton:
		player._can_shoot = true

func place_trap(current_s):
	trap_placed_audio.play()
	spaces_arr[current_s] = true
	space = current_s
	collision_layer = 1
	$CollisionShape2D.disabled = false
	animated_sprite_2d.modulate = Color("white")
	placed = true
	
	if economy_system:
		economy_system.pay_money(price)
	if navigation_button:
		navigation_button.reset_navigation()
