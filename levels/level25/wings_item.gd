extends Sprite

func _on_Area2D_body_entered(body):
	if (body.get_name() == "player"):
		body.can_fly = true
		queue_free()