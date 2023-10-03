class_name GamepadButtonsHandler
extends Node

# Текстуры кнопок виртуального геймпада: нажатые и отпущеные
# Используются для визуального отображения работоспособности кнопок
var moveleft_pressed_texture: Texture = preload("res://ui/gamepad_buttons/left_arrow_pressed.tres")
var moveright_pressed_texture: Texture = preload("res://ui/gamepad_buttons/right_arrow_pressed.tres")
var menu_pressed_texture: Texture = preload("res://ui/gamepad_buttons/menu_button_pressed.tres")
var jump_pressed_texture: Texture = preload("res://ui/gamepad_buttons/b_pressed.tres")
var shoot_pressed_texture: Texture = preload("res://ui/gamepad_buttons/a_pressed.tres")
var restart_pressed_texture: Texture = preload("res://ui/gamepad_buttons/r_pressed.tres")

var moveleft_released_texture: Texture = preload("res://ui/gamepad_buttons/left_arrow_released.tres")
var moveright_released_texture: Texture = preload("res://ui/gamepad_buttons/right_arrow_released.tres")
var menu_released_texture: Texture = preload("res://ui/gamepad_buttons/menu_button_released.tres")
var jump_released_texture: Texture = preload("res://ui/gamepad_buttons/b_released.tres")
var shoot_released_texture: Texture = preload("res://ui/gamepad_buttons/a_released.tres")
var restart_released_texture: Texture = preload("res://ui/gamepad_buttons/r_released.tres")


func get_button_texture(button_name: String, enabled: bool) -> Texture:
	var button_texture: Texture
	match button_name:
		"MoveLeft":
			if enabled:
				button_texture = moveleft_released_texture
			else:
				button_texture = moveleft_pressed_texture
		"MoveRight":
			if enabled:
				button_texture = moveright_released_texture
			else:
				button_texture = moveright_pressed_texture
		"Menu":
			if enabled:
				button_texture = menu_released_texture
			else:
				button_texture = menu_pressed_texture
		"Jump":
			if enabled:
				button_texture = jump_released_texture
			else:
				button_texture = jump_pressed_texture
		"Shoot":
			if enabled:
				button_texture = shoot_released_texture
			else:
				button_texture = shoot_pressed_texture
		"Restart":
			if enabled:
				button_texture = restart_released_texture
			else:
				button_texture = restart_pressed_texture
	return button_texture



func get_button_action(button_name: String, enabled: bool) -> String:
	if not enabled:
		return ""

	var action_name: String
	match button_name:
		"MoveLeft":
			action_name = "move_left"
		"MoveRight":
			action_name = "move_right"
		"Menu":
			action_name = "menu"
		"Jump":
			action_name = "jump"
		"Shoot":
			action_name = "shoot"
		"Restart":
			action_name = "restart"
	return action_name
