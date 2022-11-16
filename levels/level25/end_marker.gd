extends Sprite

func _on_Area2D_body_entered(body):
	if (body.get_name() == "player"):
		get_tree().get_current_scene().get_node("smiles").show()
