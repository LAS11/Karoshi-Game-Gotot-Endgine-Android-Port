extends Node2D
# Логотип

func _ready():
	$Tween.interpolate_property($Sprite, 'modulate', Color(1, 1, 1, 1),
								Color(1, 1, 1, 0), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func _on_Timer_timeout():
	$Tween.start()
