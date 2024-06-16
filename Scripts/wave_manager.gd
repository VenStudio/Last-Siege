extends Node2D

@export var waves = [[[5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0]],
[[5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0]],
[[5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0]],
[[5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0]],
[[5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0], [5.0, 0, 0, 0, 0]]]
@export var enemies = [preload("res://Scenes/basic_enemy.tscn"), preload("res://Scenes/basic_enemy.tscn"),
 preload("res://Scenes/basic_enemy.tscn"), preload("res://Scenes/basic_enemy.tscn")]
@export var spawn_margin = 25
@export var start_wave_button : Button
@export var enemies_remaining_text : Label
@export var last_cutscene_scene = preload("res://Scenes/last_story_cutscene.tscn")
@export var game_node : NodePath

@onready var wave_complete_text = $"Wave Complete Label"
@onready var wave_start_audio = $"Wave Start Audio"
@onready var wave_complete_audio = $"Wave Complete Audio"

static var enemies_count = 0

var current_wave = -1
var in_wave = false
var wave_timer = 0
var wave_group = 0
var enemies_remaining = -1
var game_manager : Node

func _ready():
	game_manager = get_tree().get_root().get_node("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not in_wave:
		return
	
	if wave_timer >= 0:
		wave_timer -= delta
	elif enemies_remaining <= 0:
		if current_wave < waves.size() - 1:
			end_wave()
		else:
			game_complete()
	elif waves[current_wave].size() > wave_group:
		wave_timer = waves[current_wave][wave_group][0]
		
		for i in range(1, waves[current_wave][wave_group].size()):
			var instance = enemies[waves[current_wave][wave_group][i]].instantiate()
			spawn_enemy(instance)
			
			instance.position = position
			instance.position.x += RandomNumberGenerator.new().randf_range(-1, 1) * spawn_margin
		
		wave_group += 1

func start_next_wave():
	wave_start_audio.play()
	current_wave += 1
	wave_group = 0
	
	enemies_remaining = 0
	for i in waves[current_wave]:
		enemies_remaining +=  i.size() - 1
	
	update_enemies_remaining()
	
	in_wave = true
	start_wave_button.visible = false

func end_wave():
	in_wave = false
	start_wave_button.visible = true
	wave_complete_text.visible = true
	wave_complete_audio.play()
	$Timer.start()

func game_complete():
	# start epilogue
	in_wave = false
	game_manager.load_scene(last_cutscene_scene)
	game_manager.unload_scene(get_node(game_node))

func spawn_enemy(instance):
	instance.name += str(enemies_count)
	enemies_count += 1
	get_tree().get_root().get_node("Game").get_node("Game Scene").add_child(instance)
	instance.economy_system = %"Economy System"
	instance.wave_manager = %"Wave Manager"

func update_enemies_remaining():
	enemies_remaining_text.text = "Enemies Remaining: " + str(enemies_remaining)


func _on_button_pressed():
	start_next_wave()

func decrease_enemies():
	enemies_remaining -= 1
	
	if enemies_remaining <= 0:
		enemies_remaining_text.text = "No Enemies Remaining!"
	else:
		enemies_remaining_text.text = "Enemies Remaining: " + str(enemies_remaining)



func _on_timer_timeout():
	wave_complete_text.visible = false
