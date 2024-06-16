extends Button

@export var obj_name = "object"

enum WeaponType {NONE, BOW, CROSSBOW}
enum SoldItem {TRAP, WEAPON, HEALTH}

@export var sold_item : SoldItem  = SoldItem.TRAP
@export var price = 0
@export var navigation_button : Button
@export var weapon_type :WeaponType
@export var scene : PackedScene

static var traps_count = 0

@onready var castle_wall = %Wall
@onready var economy_system = %"Economy System"
@onready var player = %Player
@onready var buy_audio = $"Buy Audio"

var instance : Node2D
func _ready():
	_update_state()
	
	match sold_item:
		SoldItem.TRAP:
			text = "Buy " + obj_name + "\nPrice: " + str(price)
		SoldItem.WEAPON:
			_on_player_update_weapon_type()
		SoldItem.HEALTH:
			castle_wall.heal(20)
	
	economy_system.on_update_money.connect(_update_state)

func can_buy():
	if price > economy_system.money:
		return false
	
	if not instance:
		return true
	
	if instance.placed:
		instance = null
		return true
	else:
		return false

func _on_pressed():
	if can_buy():
		buy_audio.play()
		
		match sold_item:
			SoldItem.TRAP:
				instance = scene.instantiate()
				instance.name += str(traps_count)
				traps_count += 1
				get_tree().get_root().get_node("Game").get_node("Game Scene").add_child(instance)
				
				instance.player = player
				instance.economy_system = economy_system
				instance.global_position = Vector2(100, instance.ground_level)
				instance.price = price
				print("Purchaes Trap")
			SoldItem.WEAPON:
				economy_system.pay_money(price)
				player.own_weapon(weapon_type)
				print("Purchased weapon")
			SoldItem.HEALTH:
				castle_wall.heal(20)
				economy_system.pay_money(price)
				print("Purchased Castle Health")
		
		if navigation_button:
			navigation_button.navigate()
			instance.navigation_button = navigation_button
	else:
		print("You don't have enough money")



func _on_player_update_weapon_type():
	if not sold_item == SoldItem.WEAPON:
		return
	
	if %Player.get_weapon_type() == weapon_type:
		disabled = true
		text = obj_name + "\nOwned"
		price = 0
		print(str(weapon_type))
	elif %Player.get_owned_weapons().bsearch(weapon_type) < %Player.get_owned_weapons().size():
		disabled = false
		text = "Equip\n" + obj_name
	else:
		disabled = false
		text = "Buy " + obj_name + "\nPrice: " + str(price)

func _on_wall_health_updated():
	if not sold_item == SoldItem.HEALTH:
		return
	
	if castle_wall.health >= castle_wall.max_health:
		disabled = true
		text = "Castle Health is Full"
	else:
		disabled = false
		text = "Buy +20 Castle Health" + "\nCurrent Health: " + str(castle_wall.health) + "/" + str(castle_wall.max_health) + "\nPrice: " + str(price)
		

func _update_state():
	if not can_buy():
		disabled = true
	else:
		disabled = false
	
	_on_player_update_weapon_type()
	_on_wall_health_updated()
