class_name OptionsMenu
extends Control

@onready var master_slider = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Master Slider"
@onready var sounds_slider = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Sounds Slider"
@onready var music_slider = $"Menu Items/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Music Slider"

func _ready():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	sounds_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))


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
