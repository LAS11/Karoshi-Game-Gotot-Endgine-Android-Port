extends Area2D

var texture_ebutton_pressed = preload("res://levels/level5/electro_button/ebutton_pressed.png")
var pressed = false

func _ready():
	pass

func _on_electro_button_pressed(body):
	if (body.name == "player"):
		$Sprite.set_texture(texture_ebutton_pressed)
		get_tree().get_current_scene().pressed = true