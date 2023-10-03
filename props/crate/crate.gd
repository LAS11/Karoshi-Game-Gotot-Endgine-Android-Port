class_name Crate
extends KinematicBody2D

## Ящик

const BLOCKS_COLLISION_BIT := 1
const BUTTON_BLOCKS_COLLISION_BIT := 6
const CRATE_BLOCKS_COLLISION_BIT := 7
const BULLET_COLLISION_BIT := 3

export var debug := false

var gravity: int = ProjectSettings.get_setting("gameplay/gravity_scale")
var floor_normal: Vector2 = ProjectSettings.get_setting("gameplay/floor_normal")
var _current_delta: float		# Текущее значение delta (из _physics_process)

var electrified := false		# Флаг, под напряжением ли ящик
var impulse_pushed := false 	# Флаг, толкнут ли ящик единоразовым импульсом (пулей) 
var _drop_played := true		# Флаг, воспроизводился ли звук падения
var can_pushed := true			# Флаг, можно ли сдвинуть ящик в сторону

var _push_dir := Vector2.ZERO	# Вектор направления, откуда ящик толкается
var _velocity := Vector2.ZERO	# Вектор перемещения игрока


func _physics_process(delta: float) -> void:
	_current_delta = delta

	# Поведение ящика при падении/приземлении
	if _is_in_air():
		_drop_played = false
		_velocity.y += gravity
		_check_underneath()
	else:
		_velocity.y = 0
		if not _drop_played:
			if GameData.sound_enabled:
				$DropCrate.play()
			_drop_played = true
	
	# Тормозим движение ящика по Ox
	if _velocity.x != 0 and not _is_player_pushing():
		_slow_down()
	
	# Если ящик можно сдвинуть с места - сдвинуть его
	if _has_reasons_to_move():
		_velocity = move_and_slide_with_snap(_velocity, floor_normal)
		_check_collision()


func set_button_blocks_collision(status: bool) -> void:
	set_collision_mask_bit(BUTTON_BLOCKS_COLLISION_BIT, status)


func set_crate_blocks_collision(status: bool) -> void:
	set_collision_mask_bit(CRATE_BLOCKS_COLLISION_BIT, status)


# Проверка коллизии в момент столкновения сразу после перемещения
func _check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		# Если вдруг ящик не сможет заранее обнаружить игрока под собой заранее
		# то убить его в момент столкновения 
		if collision.collider.has_method("kill") and collision.normal == Vector2.UP:
			collision.collider.kill()
		elif collision.normal.abs() == Vector2(1, 0) and \
				collision.collider.is_in_group("blocks") or \
				collision.collider.is_in_group("crates") or collision.collider.has_method("kill"):
			can_pushed = false


# Применить к ящику силу для его перемещения
func apply_force(force: float, impulse := false, from := Vector2.ZERO) -> void:
	if can_be_pushed(force):
		_velocity.x = force
	
	# Если передано направление, откуда толкается ящик - записываем его
	if from != Vector2.ZERO:
		_push_dir = from
	
	# Если толчок импульсом (т.е. пулей) - записываем это
	if impulse:
		impulse_pushed = true
		if GameData.sound_enabled:
			$BulletHit.play()
	else:
		impulse_pushed = false


func enable_electro():
	$Sprite.animation = "electro"
	electrified = true


# Проверяем, продолжает ли игрок толкать ящик
func _is_player_pushing() -> bool:
	# 1) Определяем направление толчка
	# 2) В противоположном направлении смещаем виртуально ящик, проверяем, столкнётся ли с игроком
	# 3) Если да - также проверяем, зажата ли кнопка движения в направлении толчка
	# 4) Возвращаем результат проверки
	var push_direction: float = sign(_velocity.x) # 1 - влево, -1 - вправо
	
	# При проверке инвертируем направление тестовой коллизии
	var test_velocity := Vector2(-push_direction * 6, 0) 
	var collision: KinematicCollision2D = move_and_collide(test_velocity, false, false, true)
	
	var result: bool
	if collision == null:
		result = false
	
	# Если при виртуальном смещении ящик натыкается на игрока, который толкает ящик
	elif collision.collider.has_method("kill") and \
			collision.collider._vertical_direction == push_direction:
		result = true
	return result


# Проверка, можно ли сдвинуть ящик в направлении толчка
func can_be_pushed(force: float) -> bool:
	if can_pushed:
		return true
	
	var test_velocity := Vector2(force, 0) * _current_delta # Виртуальный сдвиг на расстояние толчка
	var collision: KinematicCollision2D = move_and_collide(test_velocity, false, false, true)
	can_pushed = collision == null
	return collision == null and not _is_in_air()


# Плавно уменьшить скорость движущегося ящика
func _slow_down() -> void:
	# Если был сдвинут резким импульсом - плавно уменьшаем _velocity.x 
	if impulse_pushed: 
		var time_stop := 10 # Чем больше - тем дольше падает скорость
		var step := _velocity.x / time_stop
		_velocity.x -= step
	# Обнуляем _velocity.x при остальных случаях
	else:
		_velocity.x = 0
		_push_dir = Vector2.ZERO
	
	# Если скорость стала меньше 1 пикселя - сбрасываем до 0
	if abs(_velocity.x) < 1:
		_velocity.x = 0
		impulse_pushed = false


# Проверка, есть ли у ящика причины для перемещения
func _has_reasons_to_move() -> bool:
	return _velocity != Vector2.ZERO


# Проверка, есть ли что-то под ящиком
func _check_underneath() -> void:
	var test_velocity := Vector2(_velocity.x, _velocity.y * 2) * _current_delta
	# Виртуально смещаем ящик
	var collision: KinematicCollision2D = move_and_collide(test_velocity, 
			false, false, true)

	# Убить игрока, находящегося под падающим ящиком
	if collision != null:
		if collision.collider.has_method("kill"):
			collision.collider.kill()
		elif (collision.collider.is_in_group("blocks") or collision.collider.is_in_group("crates"))\
				and collision.normal == Vector2.UP:
			set_collision_mask_bit(BLOCKS_COLLISION_BIT, false)
	else:
		set_collision_mask_bit(BLOCKS_COLLISION_BIT, true)


# Проверка, в воздухе ли ящик
# Для этого ящик виртуально смещается ниже своего положения на move_distance
func _is_in_air() -> bool:
	# Виртуально смещаем ящик
	var test_velocity: Vector2 = Vector2(0, 8) * _current_delta
	var collision: KinematicCollision2D = move_and_collide(test_velocity, 
			false, false, true)
	
	# По наличию препятствия под ящиком определяем, в воздухе ли он 
	return collision == null


func _on_Timer_timeout():
	$DropCrate.volume_db = 0
