extends KinematicBody2D

const SPEED = 300
const JUMP_HEIGHT = 1250
const GRAVITY = 85
const FLOOR_NORMAL = Vector2(0, -1)
var velocity = Vector2()
var in_air = false
var on_ground = true
var destroyed = false
var current_level_number

func _on_Area2D_body_entered(body):
	if (body.get_name() == "player"):
		body.kill()

func _ready():
	current_level_number = get_tree().get_current_scene().get_name().to_int()
	if (current_level_number == 26):
		set_physics_process(false)
		velocity = Vector2(-SPEED, 0)
	if (current_level_number == 27 or current_level_number == 28):
		set_physics_process(false)
		velocity = Vector2(-SPEED, -1445)
	set_process(false)

func _physics_process(delta):
	if (velocity.y != 0):
		in_air = true
	else:
		in_air = false
	if (current_level_number == 26):
		if (in_air == false):
			velocity.y = -JUMP_HEIGHT
		if (position.x - SPEED*delta < 85):
			velocity.x = SPEED
		if (position.x + SPEED*delta > 555):
			velocity.x = -SPEED
		velocity.y += GRAVITY

	if (current_level_number == 27):
		if (in_air == true):
			velocity.y += GRAVITY
		if (position.x - SPEED*delta < 85):
			velocity.x = SPEED
		if (position.x + SPEED*delta > 555):
			velocity.x = -SPEED
	if (current_level_number == 28):
		if (velocity.y != 0 and destroyed == false):
			velocity.y += GRAVITY
		if (destroyed == false):
			if (position.x - SPEED*delta < 85):
				velocity.x = SPEED
			if (position.x + SPEED*delta > 523):
				velocity.x = -SPEED
		elif (destroyed == true):
			if round(position.y) != 274:
				position.y += 6

	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func fall():
	#set_physics_process(false)
	destroyed = true
	on_ground = true
	$CollisionPolygon2D.set_disabled(true)
	$fire.hide()
	$AnimationPlayer.play("fall")

func _on_AnimationPlayer_animation_finished(anim_name):
	$boss_area.set_monitoring(false)

func _on_Area2D_area_entered(area):
	if area.get_name() == "player_doll":
		area.kill()
