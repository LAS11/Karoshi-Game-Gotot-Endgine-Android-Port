extends StaticBody2D

var texture_eblock_full = preload("res://levels/level5/electro_brick/eblock_full.png")

func activate_brick():
	$Sprite.set_texture(texture_eblock_full)
	$shadow.show()
	$CollisionShape2D.disabled = false
