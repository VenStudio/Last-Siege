extends "res://Scripts/Trap.gd"

@export var damage = 10

@onready var timer = $Timer
@onready var area_2d = $"Damage Area"
@onready var detect_enemies_area = $"Detect Enemies Area"

func _on_detect_enemies_area_area_entered(area):
	if not placed:
		return
	
	if "Enemy" in area.name:
		area_2d.set_deferred("monitoring", true)
		detect_enemies_area.set_deferred("monitoring", false)

func _on_area_2d_area_entered(area):
	if not placed:
		return
	
	if "Enemy" in area.name:
		area_2d.set_deferred("monitoring", false)
		animated_sprite_2d.play("Attack")
		area.take_damage(damage)
		timer.start()

func _on_timer_timeout():
	detect_enemies_area.set_deferred("monitoring", true)


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "Attack":
		animated_sprite_2d.play("Idle")
