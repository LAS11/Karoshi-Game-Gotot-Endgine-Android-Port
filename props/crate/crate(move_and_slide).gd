extends KinematicBody2D

const GRAVITY_SCALE = 50
const FLOOR_NORMAL = Vector2.UP
const FRICTION_SCALE = 10

var velocity = Vector2()
var electrified = false
var only_x = false
var on_crate = false
export var debug = false

func _physics_process(delta):
	
	if (is_on_floor()):
		velocity.y = 0
	else:
		velocity.y += GRAVITY_SCALE
		only_x == false
		on_crate = false
	
	if (velocity.x < 0):
		velocity.x += FRICTION_SCALE
	elif (velocity.x > 0):
		velocity.x -= FRICTION_SCALE
	
	if (get_slide_count() != 0):
		for i in range(0, get_slide_count()):
			
			var collision = get_slide_collision(i).get_collider()
			var collision_normal = get_slide_collision(i).get_normal()
			var collision_travel = get_slide_collision(i).get_travel()
			
			#пули могут удалиться до того, как этот цикл их обработает
			#поэтому ломаем цикл если нужно
			if (collision == null):
				break
			if (collision.get_name() == "player"):
				if (collision_normal == FLOOR_NORMAL):
					if (collision_travel.y > 0.5):
						collision.kill()
			if collision_normal == Vector2.UP:
				only_x == true
				if collision.is_in_group("crates"):
					on_crate = true

	if (only_x):
		velocity.y == 0
	if (on_crate):
		velocity.x == 0
	move_and_collide(velocity)
	if (debug):
		print(velocity)

func electrify():
	electrified = true