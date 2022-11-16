extends Area2D

func _on_pistol_picked(body):
	if (body.get_name() == "player"):
		body.has_weapon = true
		queue_free()