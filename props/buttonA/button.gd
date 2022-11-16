extends Area2D

var button_was_pressed = false
var current_scene_name
var current_scene

func _ready():
	current_scene = get_tree().get_current_scene()
	current_scene_name = get_tree().get_current_scene().get_name().to_int()

func _on_press_button(body):
	#ниже идут сценарии для конкретных уровней
	if (current_scene_name == 4):
		if (button_was_pressed == false):
			current_scene.get_node("hammer").rotate_hammer()
			button_was_pressed = true
	if (current_scene_name == 20):
		if (button_was_pressed == false):
			current_scene.get_node("rocket_flower").activate()
			button_was_pressed = true
	else:
		current_scene.pressed_Abuttons += 1
	

func _on_release_button(body):
	if (button_was_pressed == false):
		current_scene.pressed_Abuttons -= 1
