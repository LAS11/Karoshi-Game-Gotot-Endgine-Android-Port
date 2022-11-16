extends Node

var current_scene_number
var restart = 0

func _process(delta):
	current_scene_number = get_tree().get_current_scene().get_name().to_int()
	if (current_scene_number == 21):
		if Input.is_action_just_pressed("restart"):
			restart += 1
	else:
		restart = 0
