extends Sprite

const SPEED = 8
const ANGLE = 5
var rotate_direction

func _ready():
	randomize()
	#получаем одно из двух чисел: 0, 1
	rotate_direction = randi() % 2
	var x_pos = randi() % 560
	var y_pos = -(randi() % 128) - (randi() % 500)
	position = Vector2(x_pos, y_pos)
	print(position)

func _physics_process(delta):
	#0 - по часовой стрелке
	#1 - против часовой стрелки
	if rotate_direction == 0:
		rotate(deg2rad(ANGLE))
	else:
		rotate(deg2rad(-ANGLE))
	position.y += SPEED

func _on_basket_collide(body):
	if (body.get_name() == "player"):
		body.kill()
