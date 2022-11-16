extends KinematicBody2D

const GRAVITY_SCALE = 50
const WALK_SPEED = 280
const JUMP_HEIGHT = 800
const FLOOR_NORMAL = Vector2(0, -1)
const CRATE_MOVEMENT_SPEED = 2

var velocity = Vector2()
var in_air = false
var can_jump = false

var left_pressed
var right_pressed

func _physics_process(delta):

	left_pressed = Input.is_action_pressed("ui_left")
	right_pressed = Input.is_action_pressed("ui_right")

	#ходьба + её анимация
	velocity.y += GRAVITY_SCALE
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	if (velocity.x != 0):
		$AnimatedSprite.animation = "walk"
	else:
		$AnimatedSprite.animation = "idle"

	if left_pressed:
		velocity.x = -WALK_SPEED
	elif right_pressed:
		velocity.x = WALK_SPEED
	else:
		velocity.x = 0

	#прыжки
	if (velocity.y != 0):
		in_air = true
	else:
		in_air = false
	if (Input.is_action_pressed("ui_jump")):
		#nput.action_release("ui_jump")
		if ((not in_air) and can_jump):
			velocity.y = -JUMP_HEIGHT
	can_jump = not Input.is_action_pressed("ui_jump")

	# толкаем ящики
	# перебираем все коллизии игрока
	if (get_slide_count() != 0):
		for i in range(0, get_slide_count()):
			var collision = get_slide_collision(i).get_collider()
			var collision_normal = get_slide_collision(i).get_normal()
			#если игрок упёрся в ящик
			if (collision.is_in_group("crates")):
				# то смещаем его на CRATE_MOVEMENT_SPEED пикселей
				# (0, -1) - стою на ящике
				# (1, 0) - толкаю его справа налево
				# (-1, 0) - толкаю его слева направо
				if ((self.velocity.x == WALK_SPEED) and (collision_normal == Vector2(-1, 0))):
					collision.position.x += CRATE_MOVEMENT_SPEED
				elif (self.velocity.x == -WALK_SPEED) and (collision_normal == Vector2(1, 0)):
					collision.position.x -= CRATE_MOVEMENT_SPEED