extends "res://Scripts/Trap.gd"

@export var health:int = 50
@export var caslte = false
@export var health_bar : TextureProgressBar
@export var game_over_scene = preload("res://Scenes/game_over.tscn")
@export var game_node : NodePath

var max_health = 50

@onready var timer = $Timer
@onready var wall_broken = $"Wall Broken"

signal health_updated

var game_manager : Node

func _ready():
	game_manager = get_tree().get_root().get_node("Game")
	health_bar.max_value = health
	health_bar.value = health
	
	if caslte:
		placed = true
		max_health = health
		collision_layer = 2
	
	super._ready()

func take_damage(damage):
	health -= damage
	animated_sprite_2d.modulate = Color("red")
	timer.start()
	emit_signal("health_updated")
	
	health_bar.visible = true
	health_bar.value = health
	
	if health < 0:
		wall_broken.play()
		wall_broken.reparent(get_tree().get_root().get_node("Game"))
		
		if caslte:
			game_manager.load_scene(game_over_scene, 1)
			game_manager.unload_scene(get_node(game_node))
		else:
			on_destroy()

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	
	emit_signal("health_updated")

func on_destroy():
	spaces_arr[space] = false
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$ShapeCast2D.enabled = false
	$"Wall Health Bar".visible = false
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_timer_timeout():
	animated_sprite_2d.modulate = Color("white")

func place_trap(current_s):
	super.place_trap(current_s)
	collision_layer = 2
