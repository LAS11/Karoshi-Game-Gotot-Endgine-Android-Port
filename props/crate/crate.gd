extends KinematicBody2D

const GRAVITY_SCALE = 50
const FLOOR_NORMAL = Vector2.UP
const FRICTION_SCALE = 8
const AIR_FRICTION_SCALE = 50

var velocity = Vector2()
var electrified = false
var collision
var collision_collider
var collision_normal
var collision_travel
export var is_movable = true
export var debug = false

func _physics_process(delta):

	if (not collision):
		velocity.y += GRAVITY_SCALE
	else:
		collision_collider = collision.get_collider()
		collision_normal = collision.get_normal()
		collision_travel = collision.get_travel()
		
		if collision_collider != null:
			
			if (collision_normal == FLOOR_NORMAL):
				velocity.y = 0
			else:
				velocity.y += GRAVITY_SCALE
			
			if (collision_collider.is_in_group("crates")) or (collision_collider.is_in_group("geometry")):
				if ((collision_normal == Vector2.LEFT) or (collision_normal == Vector2.RIGHT)):
					is_movable = false
					velocity.x = 0
			if (collision_collider.get_name() == "player"):
				if (collision_normal == FLOOR_NORMAL):
					if (collision_travel.y > 0.5):
						collision_collider.kill()
			if (collision_collider.get_name() == "player_shadow"):
				if (collision_normal == FLOOR_NORMAL):
					if (collision_travel.y > 0.5):
						collision_collider.queue_free()
						get_tree().get_current_scene().get_node("player").kill()
	
	if (velocity.x < 0):
#		if (collision_collider == null):
#			velocity.x += AIR_FRICTION_SCALE
#			if (velocity.x + AIR_FRICTION_SCALE > 0):
#				velocity.x = 0
#		else:
			velocity.x += FRICTION_SCALE
			if (velocity.x + FRICTION_SCALE > 0):
				velocity.x = 0
	if (velocity.x > 0):
#		if (collision_collider == null):
#			velocity.x -= AIR_FRICTION_SCALE
#			if (velocity.x - AIR_FRICTION_SCALE < 0):
#				velocity.x = 0
#		else:
			velocity.x -= FRICTION_SCALE
			if (velocity.x - FRICTION_SCALE < 0):
				velocity.x = 0
		
	collision = move_and_collide(velocity * delta)
	if debug:
		print(velocity)