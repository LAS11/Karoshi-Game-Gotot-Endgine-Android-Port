extends Area2D
# Шипы

func _on_Spikes_body_entered(body):
	if body.has_method("kill"):
		set_deferred("monitoring", false)
		body.call_deferred("kill")
