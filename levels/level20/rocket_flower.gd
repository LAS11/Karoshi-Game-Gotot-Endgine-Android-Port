extends Sprite

const SPEED = 10
var activated = false

func _process(delta):
	if activated:
		position.y -= SPEED

func activate():
	$fire.show()
	activated = true
	get_tree().get_current_scene().get_node("Timer").start()