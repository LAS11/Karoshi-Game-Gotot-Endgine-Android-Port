extends Area2D

func kill():
	#конвертируем номер текущего уровня в int и увеличиваем на 1
	#тем самым получая номер следующего уровня
	var next_level = (get_tree().get_current_scene().get_name().to_int()) + 1
	get_tree().change_scene("res://levels/level" + String(next_level) + ".tscn")