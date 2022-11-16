extends StaticBody2D

func destroy():
	$AnimationSprite.play("destroy")

func _on_AnimationSprite_animation_finished():
	queue_free()
