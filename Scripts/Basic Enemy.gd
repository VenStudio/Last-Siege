extends Area2D

@export var health = 8
@export var speed = 20
@export var money = 3
@export var damage : float = 1
@export var range_variance = 50

@onready var fire_rate = $"Fire Rate"
@onready var hit_timer = $"Hit Timer"
@onready var ray_cast_2d = $RayCast2D
@onready var economy_system = 0
@onready var wave_manager = 0
@onready var enemy_health_bar = $"Enemy Health Bar"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attack_audio = $"Attack Audio"
@onready var take_damage_audio = $"Take Damage Audio"
@onready var footsteps_audio = $"Footsteps Audio"

var max_speed = 20
var slowness_counts = 0
var reloading = true

func _ready():
	max_speed = speed
	enemy_health_bar.max_value = health
	enemy_health_bar.value = health
	ray_cast_2d.target_position.x += RandomNumberGenerator.new().randf_range(-1, 1) * range_variance
	animated_sprite_2d.play("Idle")
	fire_rate.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_2d.is_colliding():
		var wall = ray_cast_2d.get_collider()
		if not reloading:
			animated_sprite_2d.play(("Attack"))
			attack_audio.play()
			footsteps_audio.stop()
			wall.take_damage(damage)
			reloading = true
			fire_rate.start()
	elif not reloading:
		position.x -= speed * delta
		animated_sprite_2d.play("Walk")
		if not footsteps_audio.playing:
			footsteps_audio.play()



func take_damage(d, play_sound : bool = true):
	if health <= 0:
		return
	
	health -= d
	enemy_health_bar.value = health
	if play_sound:
		take_damage_audio.play()
	animated_sprite_2d.modulate = Color("red")
	hit_timer.start()
	
	if health <= 0:
		on_death()

func apply_slowness(slowness):
	speed = max_speed * slowness
	animated_sprite_2d.speed_scale = slowness
	animated_sprite_2d.modulate = Color("cyan")
	slowness_counts += 1

func remove_slowness():
	slowness_counts -= 1
	
	if slowness_counts <= 0:
		speed = max_speed
		animated_sprite_2d.speed_scale = 1
		animated_sprite_2d.modulate = Color("white")

func on_death():
		enemy_health_bar.value = 0
		economy_system.recieve_money(money)
		wave_manager.decrease_enemies()
		$AnimatedSprite2D.visible = false
		$".".set_deferred("monitorable", false)
		$".".set_deferred("monitoring", false)
		$RayCast2D.enabled = false
		$"Enemy Health Bar".visible = false
		$LightOccluder2D.visible = false
		footsteps_audio.stop()
		fire_rate.stop()
		hit_timer.stop()
		await get_tree().create_timer(2).timeout
		queue_free()

func _on_body_entered(body):
	if "Arrow" in body.name:
		take_damage(body.damage)
		body.animated_sprite_2d.visible = false
		body.collision_shape_2d.set_deferred("disabled", true)
		await get_tree().create_timer(0.5).timeout
		body.queue_free()

func _on_fire_rate_timeout():
	reloading = false


func _on_hit_timer_timeout():
	if speed != max_speed:
		animated_sprite_2d.modulate = Color("cyan")
	else:
		animated_sprite_2d.modulate = Color("white")


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "Attack":
		animated_sprite_2d.play(("Idle"))


func _on_footsteps_audio_finished():
	if Engine.time_scale != 0:
		footsteps_audio.play()
	else:
		footsteps_audio.stop()
