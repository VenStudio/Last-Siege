extends "res://Scripts/Trap.gd"

@export_range(0, 1) var slowness = 0.6
@export var damage = 1

@onready var timer = $Timer
@onready var area_2d = $"Slowness Area"
@onready var crystal_aura = $"Slowness Area/CollisionShape2D/Crystal Aura"
@onready var crystal_audio = $"Crystal Audio"

var enemies = []
var ini_enemies = 0

func _ready():
	animated_sprite_2d.play("Idle")
	crystal_aura.play("Idle")

func activate(area):
	animated_sprite_2d.play("Active")
	
	if crystal_aura.animation == "Idle":
		crystal_aura.play("Start")
		crystal_audio.play()
		ini_enemies += 1
	else:
		area.apply_slowness(slowness)
		
	timer.start()

func _on_area_2d_area_entered(area):
	
	if "Enemy" in area.name:
		enemies.append(area)
		
		if not placed:
			return
		
		activate(area)

func _on_slowness_area_area_exited(area):
	enemies.erase(area)
	
	if not placed:
		return
	
	area.remove_slowness()
	if enemies.size() <= 0:
		crystal_aura.play_backwards("Start")

func _on_timer_timeout():
	if enemies.size() > 0:
		for area in enemies:
			area.take_damage(damage, false)
		timer.start()
	else:
		animated_sprite_2d.play("Idle")



func _on_crystal_aura_animation_finished():
	if crystal_aura.animation == "Start" and enemies.size() > 0:
			crystal_aura.play("Active")
			for i in range(0, ini_enemies):
				enemies[i].apply_slowness(slowness)
			ini_enemies = 0
	else:
		crystal_aura.play("Idle")

func place_trap(current_s):
	super.place_trap(current_s)
	
	for area in enemies:
		activate(area)
