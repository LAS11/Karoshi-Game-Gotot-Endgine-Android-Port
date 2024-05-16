class_name Player
extends KinematicBody2D
# Игрок


signal died # Игрок умер

const SPEED := 245					# Скорость движения
const JUMP_HEIGHT := 825			# Высота обычного прыжка
const WINGS_JUMP_HEIGHT := 450		# Высота прыжка в полёте (при наличие крыльев)
const PUSH_CRATE_FORCE := 115.0

export var has_weapon := false		# Есть ли у игрока оружие
export var has_wings := false setget _set_wings		# Есть ли у игрока крылья
export var inverse_movement := false # Перепутаны ли кнопки перемещения

# Флаги состояния
var is_shooting := false
var moving_left := false
var moving_right := true
var can_spawn_bullet := true
var in_air := true
var killed := false
var invincible := false
var pushing_crate := false


# Параметры перемещения/коллизии
var _vertical_direction := 1.0	# Направление взгляда/движения
var _velocity: Vector2			# Вектор скорости перемещения
var _collision: KinematicCollision2D


# Эти параметры прописаны в параметрах проекта (Project -> Project Settings...)
var gravity: int = ProjectSettings.get_setting("gameplay/gravity_scale") # Величина гравитации
var floor_normal: Vector2 = ProjectSettings.get_setting("gameplay/floor_normal") # Нормаль земли
var test_shape := Physics2DShapeQueryParameters.new()


# Подгрузка файлов
var bullet = preload("res://props/pistol/bullet.tscn")	# Заранее подгружаем сцену с пулей
var jump1 = preload("res://player/player_jump1.wav")
var jump2 = preload("res://player/player_jump2.wav")
var jump3 = preload("res://player/player_jump3.wav")


# Если игрок спавнится с крыльями - активируем спрайт крыльев
func _ready():
	$WingsSprite.set_visible(has_wings)


# Обработка перемещения игрока
# Похоже, что для перемещения нужно покадрово обрабатывать кнопки
func _physics_process(_delta: float) -> void:
	_check_player_direction()

	_velocity.x = SPEED * _vertical_direction
	_velocity.y += gravity
	_velocity = move_and_slide(_velocity, floor_normal, true, 4,  0.785398, true)
	_check_collision()
	
	_animate_player()
	_animate_wings()


# Обработка кнопок движения
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_jump()
	
	if event.is_action_pressed("shoot"):
		if has_weapon:
			_shoot()
		elif $NoWeaponMessage.visible == false:
			$NoWeaponMessage.show_message()


# Убийство игрока
func kill() -> void:
	killed = true
	set_physics_process(false)
	set_process_unhandled_input(false)
	
	$PlayerSprite.hide()
	$WingsSprite.hide()
	
	$NoWeaponMessage.hide()
	$NoWeaponMessage.queue_free()
	
	$PlayerRagdoll.show()
	$PlayerRagdoll.explode(has_wings)
	
	if GameData.sound_enabled:
		$DeathSound.play()
	
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("died")
	

func _check_collision() -> void:
	if get_slide_count() == 0:
		pushing_crate = false
	
	for i in get_slide_count():
		var normal = get_slide_collision(i).normal
		var collider = get_slide_collision(i).collider
		
		if collider is Crate:
			# Если ящик наэлектризован
			if collider.electrified:
				$PlayerSprite.set_deferred("animation", "shocked")
				set_physics_process(false)
				set_process_unhandled_input(false)
				$Timer.start(1.0)
			# Если ящик находится слева/справа, и разница в высоте между игроком и ним мала
			elif normal.abs() == Vector2.RIGHT and abs(collider.position.y - position.y) < 20:
				collider.apply_force(-normal.x * PUSH_CRATE_FORCE, false, normal)
				pushing_crate = collider.can_be_pushed(-normal.x * PUSH_CRATE_FORCE)
			else:
				pushing_crate = false
		else:
			pushing_crate = false
		
		if collider is Bullet:
			kill()


# Стрельба
func _shoot() -> void:
	is_shooting = true
	if GameData.sound_enabled:
		$ShootSound.play()
	
	if $BulletCast.get_collider() != null:
		return
	
	# Пуля добавляется чайлдом корню сцены, а не игроку (иначе будут двигаться с ним)
	var b = bullet.instance()
	b.position = $BulletCast/BulletSpawn.global_position
	
	if moving_left:
		b.moving_direction *= -1
		b.get_node("Sprite").flip_h = true
	
	get_parent().add_child(b) 


# Прыжок
func _jump() -> void:
	if is_on_floor():
		_velocity.y = -JUMP_HEIGHT
		if GameData.sound_enabled:
			_select_jump_sound()
			$JumpSound.play()
	elif has_wings:
		_velocity.y = -WINGS_JUMP_HEIGHT


# Проигрывание анимаций движения
func _animate_player() -> void:
	# Анимации вне стрельбы
	if not is_shooting:
		$PlayerSprite.flip_h = false
		if _velocity.x != 0 or pushing_crate:
			$PlayerSprite.play("walk")
		else:
			$PlayerSprite.play("idle")
	# Анимации во время стрельбы
	else:
		if moving_left: 
			$PlayerSprite.flip_h = false 
			$PlayerSprite.offset = Vector2(-8, 0)
		else:
			$PlayerSprite.flip_h = true
			$PlayerSprite.offset = Vector2(7, 0)
		$PlayerSprite.play("shoot")


# Проигрывание анимаций ходьбы
func _animate_wings():
	if not is_on_floor() and has_wings:
		$WingsSprite.play("fly")
	else:
		$WingsSprite.play("idle")


# Проверяем направление перемещения
func _check_player_direction() -> void:
	_vertical_direction = Input.get_action_strength("move_right") - \
			Input.get_action_strength("move_left") # -1 - идёт влево, 1 - вправо
	
	if inverse_movement:
		_vertical_direction *= -1
	
	if _vertical_direction < 0:
		$BulletCast.position = Vector2(-8, 0)
		$BulletCast.rotation_degrees = -270
		moving_left = true
		moving_right = false
	elif _vertical_direction > 0:
		$BulletCast.position = Vector2(8, 0)
		$BulletCast.rotation_degrees = -90
		moving_left = false
		moving_right = true


# Выбор случайного звука прыжка
func _select_jump_sound():
	match randi() % 3:
		0:
			$JumpSound.stream = jump1
		1:
			$JumpSound.stream = jump2
		2:
			$JumpSound.stream = jump3


# Сеттер переменной has_wings, активирует крылья в зависимости от их наличия у игрока
func _set_wings(value):
	has_wings = value
	$WingsSprite.set_visible(has_wings)
	
	
# Поведение по окончанию анимации выстрела
# (можно и для других анимаций)
func _on_PlayerSprite_animation_finished():
	if $PlayerSprite.animation == "shoot":
		$PlayerSprite.animation = "idle"
		$PlayerSprite.offset = Vector2(0, 0)
		is_shooting = false


func _on_Timer_timeout():
	kill()
