extends Node

@export var money = 0
@export var money_text: Array[Label] = []

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
		m.text = "Money: " + str(money)
