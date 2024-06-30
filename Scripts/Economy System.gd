extends Node

@export var money = 0
@export var money_text: Array[Label] = []

@onready var place_trap_tip_label = $"../Camera2D/UI/Place Trap Tip Label"
@onready var navigation_button = $"../Buttons/Navigation/Navigation Button"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_money()


func pay_money(price):
	if price > money:
		return false
	else:
		money -= price
		update_money()
		return true

func recieve_money(amount):
	money += amount
	update_money()

signal on_update_money

func update_money():
	on_update_money.emit()
	for m in money_text:
		m.text = str(money) + "G"

func set_tip(state:bool) -> void:
	place_trap_tip_label.visible = state
	navigation_button.visible = !state
	$"../Buttons/Settings Button".visible = !state
	if %"Wave Manager".in_wave == false:
		$"../Buttons/Start Next Wave Button".visible = !state
