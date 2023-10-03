class_name DefaultButton
extends Area2D
# Кнопка, активируемая нажатием объекта

signal pressed
signal released

var pressed := false


func press_button():
	pressed = true
	emit_signal("pressed")


func release_button():
	pressed = false
	emit_signal("released")
