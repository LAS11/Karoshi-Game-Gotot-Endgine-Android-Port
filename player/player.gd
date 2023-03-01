extends KinematicBody2D

const GRAVITY_SCALE = 50
const WALK_SPEED = 280
const FLY_POWER = 375
const JUMP_HEIGHT = 800
const FLOOR_NORMAL = Vector2(0, -1)
const SHOOT_DELAY = 1
const CRATE_MOVEMENT_SPEED = 2

var velocity = Vector2()
var in_air = false
var can_jump = false
var has_weapon = false
var can_shoot = true
var faced_right = true
var faced_left = false
export var can_fly = false

var restart_pressed
var exit_pressed
var shoot_pressed
var current_scene
var current_scene_number
var left_pressed
var right_pressed
var platform

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if (current_scene_number != 12):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func _physics_process(delta):
	platform = OS.get_name()
	restart_pressed = Input.is_action_pressed("restart")
	exit_pressed = Input.is_action_pressed("exit")
	shoot_pressed = Input.is_action_pressed("ui_shoot")
	current_scene = get_tree().get_current_scene()
	current_scene_number = get_tree().get_current_scene().get_name().to_int()
	
	if (can_fly == true):
		$Wings.show()
	
	if (current_scene_number != 21):
		left_pressed = Input.is_action_pressed("ui_left")
		right_pressed = Input.is_action_pressed("ui_right")
	else:
		if (restart_counter.restart % 2 == 1):
			left_pressed = Input.is_action_pressed("ui_left")
			right_pressed = Input.is_action_pressed("ui_right")
		elif (restart_counter.restart % 2 == 0):
			left_pressed = Input.is_action_pressed("ui_right")
			right_pressed = Input.is_action_pressed("ui_left")

	#ходьба + её анимация
	velocity.y += GRAVITY_SCALE
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	if (velocity.x != 0):
		$AnimatedSprite.animation = "walk"
	else:
		$AnimatedSprite.animation = "idle"
	
	if restart_pressed:
		if (current_scene_number != 21):
			get_tree().reload_current_scene()
	if exit_pressed:
		if (platform == "Windows"):
			get_tree().quit()
		elif (platform == "Android"):
			get_tree().change_scene("res://main_menu/main_menu.tscn")
	if left_pressed:
		velocity.x = -WALK_SPEED
		$Position2D.position.x = -25
		$RayCast2D.set_cast_to(Vector2(0, -25))
		faced_right = false
		faced_left = true
	elif right_pressed:
		velocity.x = WALK_SPEED
		$Position2D.position.x = 25
		$RayCast2D.set_cast_to(Vector2(0, 25))
		faced_right = true
		faced_left = false
	else:
		velocity.x = 0
	
	#стрельба
	if shoot_pressed:
		if can_shoot:
			Input.action_release("ui_shoot")
			$ShootTimer.start()
			can_shoot = false
			if has_weapon:
				if ($RayCast2D.is_colliding() == false):
					var bullet = preload ("res://props/pistol/bullet.tscn").instance()
					if faced_right:
						$AnimatedSprite.animation = "shoot_right"
						bullet.bullet_velocity.x = bullet.BULLET_SPEED
					elif faced_left:
						$AnimatedSprite.animation = "shoot_left"
						bullet.flip_bullet_sprite('h')
						bullet.bullet_velocity.x = -bullet.BULLET_SPEED
					bullet.position = $Position2D.global_position
					get_parent().add_child(bullet)
			else:
				$Message.modulate = Color(1, 1, 1, 1)
				$Message/Timer.start()
	
	#прыжки
	if (velocity.y != 0):
		in_air = true
		$Wings.play("fly")
	else:
		in_air = false
		$Wings.play("idle")
	if (Input.is_action_pressed("ui_jump")):
		#Input.action_release("ui_jump")
		if can_fly:
			if in_air == false:
				velocity.y = -JUMP_HEIGHT
			elif in_air == true:
				velocity.y = -FLY_POWER
		if (can_jump):
			velocity.y = -JUMP_HEIGHT
			can_jump = false
	
	# толкаем ящики
	# перебираем все коллизии игрока
	if (get_slide_count() != 0):
		for i in range(0, get_slide_count()):
			var collision = get_slide_collision(i).get_collider()
			var collision_normal = get_slide_collision(i).get_normal()
			#если игрок упёрся в ящик
			if (collision_normal == Vector2.UP):
				can_jump = true
			if (collision.is_in_group("crates")):
				# то смещаем его на CRATE_MOVEMENT_SPEED пикселей
				# (0, -1) - стою на ящике
				# (1, 0) - толкаю его справа налево
				# (-1, 0) - толкаю его слева направо
				if collision.is_movable:
					if ((self.velocity.x == WALK_SPEED) and (collision_normal == Vector2(-1, 0))):
						collision.position.x += CRATE_MOVEMENT_SPEED
					elif (self.velocity.x == -WALK_SPEED) and (collision_normal == Vector2(1, 0)):
						collision.position.x -= CRATE_MOVEMENT_SPEED
				if (collision.electrified):
					kill()
	
	if (abs(position.y) > 500):
		kill()

func kill():
	#конвертируем номер текущего уровня в int и увеличиваем на 1
	#тем самым получая номер следующего уровня
	var next_level = current_scene_number + 1
	get_tree().change_scene("res://levels/level" + String(next_level) + ".tscn")
	#get_tree().reload_current_scene()


func _on_msg_Timer_timeout():
	$Message/Tween.interpolate_property($Message, 'modulate', Color(1, 1, 1, 1), 
									Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, 
									Tween.EASE_IN_OUT)
	$Message/Tween.start()

#таймер сбрасывает возможность стрельбы
func _on_shoot_timer_timeout():
	can_shoot = true
