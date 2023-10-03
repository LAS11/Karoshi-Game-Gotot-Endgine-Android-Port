extends KinematicBody2D

signal died # Игрок умер

const SPEED := 275					# Скорость движения
const JUMP_HEIGHT := 950			# Высота обычного прыжка

var moving_left := false
var moving_right := true

# Параметры перемещения/коллизии
var _vertical_direction := 1.0	# Направление взгляда/движения
var _velocity: Vector2			# Вектор скорости перемещения
var _collision: KinematicCollision2D

# Эти параметры прописаны в параметрах проекта (Project -> Project Settings...)
var gravity: int = ProjectSettings.get_setting("gameplay/gravity_scale") # Величина гравитации
var floor_normal: Vector2 = ProjectSettings.get_setting("gameplay/floor_normal") # Нормаль земли

var jump1 = preload("res://player/player_jump1.wav")
var jump2 = preload("res://player/player_jump2.wav")
var jump3 = preload("res://player/player_jump3.wav")
var current_delta: float


func _physics_process(_delta: float) -> void:
	current_delta = _delta
	_vertical_direction = _check_player_direction()
	
	_velocity.x = SPEED * _vertical_direction
	_velocity.y += gravity
	$PlayerDetector.monitoring = _velocity.y > 50
	_velocity = move_and_slide(_velocity, floor_normal, true, 4,  0.785398, true)


func kill() -> void:
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	set_process_unhandled_input(false)
	$PlayerDetector.monitoring = false
	if GameData.sound_enabled:
		$DeathSound.play()
	hide()
	emit_signal("died")


# Обработка кнопок движения
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_jump()


# Прыжок
func _jump() -> void:
	if is_on_floor():
		_velocity.y = -JUMP_HEIGHT
		if GameData.sound_enabled:
			_select_jump_sound()
			$JumpSound.play()


# Выбор случайного звука прыжка
func _select_jump_sound():
	match randi() % 3:
		0:
			$JumpSound.stream = jump1
		1:
			$JumpSound.stream = jump2
		2:
			$JumpSound.stream = jump3


func _check_player_direction() -> float:
	 # -1 - идёт влево, 1 - вправо
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")


func _on_PlayerDetector_body_entered(body):
	if body.has_method("kill"):
		body.call_deferred("kill")
