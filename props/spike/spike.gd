extends Area2D

func _on_spike_body_entered(body):
	if (body.get_name() == "player"):
		body.kill()


func _on_spike_area_entered(area):
	if (area.get_name() == "boss_area"):
		area.find_parent("boss_player").kill()