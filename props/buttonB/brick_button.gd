extends Area2D

func _on_brick_button_pressed(body):
	get_tree().get_current_scene().pressed_Bbuttons += 1

func _on_brick_button_released(body):
	get_tree().get_current_scene().pressed_Bbuttons -= 1
