extends Node2D

enum WeaponType {NONE, BOW, CROSSBOW}

@export var weapon_type : WeaponType
@export var space_between_shots = 2
@export var bullet = preload("res://Scenes/arrow.tscn")
@export var weapons_textures = [preload("res://Assets/Sprites/Bow.png"), preload("res://Assets/Sprites/Crossbow.png")]

@onready var weapon = $Weapon
@onready var fire_rate = $"Fire Rate"

static var bullets_count = 0

var bullet_speed = 1500
var bullet_damage = 3
var multishot = 1

var _can_shoot: bool = false
var allow_hold: bool = false
var reloading = false

var owned_weapons = [0]
signal update_weapon_type

# Called when the node enters the scene tree for the first time.
func _ready():
	change_weapon(weapon_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_pressed("shoot")  and not reloading and allow_hold:
		shoot()

func _unhandled_input(event):
	if event.is_action_pressed("shoot") and _can_shoot:
		allow_hold = true
		
		if not reloading:
			shoot()
	elif event.is_action_released("shoot"):
		allow_hold = false
	
	if event is InputEventMouseMotion:
		if get_global_mouse_position().x > weapon.position.x:
			weapon.look_at(get_global_mouse_position())
		
		_can_shoot = true
	else:
		_can_shoot = false

func shoot():
	for i in range(-int(multishot / 2), int(multishot / 2) + 1):
		var instance = bullet.instantiate()
		instance.name += str(bullets_count)
		bullets_count += 1
		instance.position = get_global_position()
		instance.rotation_degrees = weapon.rotation_degrees + space_between_shots * i
		instance.linear_velocity = Vector2(bullet_speed, 0).rotated(weapon.rotation + deg_to_rad(space_between_shots * i))
		instance.damage = bullet_damage
		
		get_tree().get_root().get_node("Game").get_node("Game Scene").add_child(instance)
	
	reloading = true
	fire_rate.start()

func _on_fire_rate_timeout():
	reloading = false

func change_weapon(new_weapon):
	weapon_type = WeaponType.values()[new_weapon]
	weapon.texture = weapons_textures[new_weapon - 1]
	
	emit_signal("update_weapon_type")
	
	match weapon_type:
		WeaponType.NONE:
			pass
		WeaponType.BOW:
			bullet_speed = 1500
			bullet_damage = 1
			fire_rate.wait_time = 0.33
			multishot = 1
		WeaponType.CROSSBOW:
			bullet_speed = 1800
			bullet_damage = 1.5
			fire_rate.wait_time = 0.6
			multishot = 3

func get_weapon_type() -> WeaponType:
	return weapon_type

func own_weapon(new_weapon):
	owned_weapons.append(new_weapon)
	print(str(WeaponType.values()[new_weapon]) + "is now owned")
	change_weapon(new_weapon)

func get_owned_weapons():
	return owned_weapons

