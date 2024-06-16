extends "res://Scripts/Basic Enemy.gd"

@export var infantry_Scene = preload("res://Scenes/infantry_enemy.tscn")
@export var spawn_locations = [Vector2(-1, 0), Vector2(1, 0)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_2d.is_colliding():
		var wall = ray_cast_2d.get_collider()
		attack_audio.play()
		wall.take_damage(damage)
		on_death()
	else:
		position.x -= speed * delta
		animated_sprite_2d.play("Walk")

func on_death():
	for location in spawn_locations:
		var instance = infantry_Scene.instantiate()
		wave_manager.enemies_remaining += 1
		wave_manager.update_enemies_remaining()
		wave_manager.spawn_enemy(instance)
		
		instance.global_position = global_position + location
	
	super.on_death()
