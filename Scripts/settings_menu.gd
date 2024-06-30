class_name OptionsMenu
extends Control

@onready var master_slider = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Master Slider"
@onready var sounds_slider = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Sounds Slider"
@onready var music_slider = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Music Slider"
@onready var option_button = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/OptionButton"
@onready var full_screen_toggle = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/FullScreen Toggle"

var language : Array[String] = ["en", "ar"]
static var lang_index = 0

func _ready():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	sounds_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	option_button.select(lang_index)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		full_screen_toggle.button_pressed = true
	else:
		full_screen_toggle.button_pressed = false


func _on_full_screen_toggle_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_master_slider_value_changed(value):
	volume(0, value)


func _on_sounds_slider_value_changed(value):
	volume(1, value)


func _on_music_slider_value_changed(value):
	volume(2, value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_option_button_item_selected(index):
	TranslationServer.set_locale(language[index])
	get_tree().get_root().get_node("Game").update()
	lang_index = index
