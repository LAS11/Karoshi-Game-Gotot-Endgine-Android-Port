class_name Bullet
extends KinematicBody2D
# Пуля, выпускаемая игроком при наличии у него пистолета

# При контакте с ящиками, игроком и обычными стенами, пуля исчезает
# И лишь при контакте с отражающими (фиолетовыми) блоками,
# пуля продолжает движение, изменив траекторию полёта 

export var moving_direction := Vector2.RIGHT 	# Единичный вектор направления движения

var BULLET_SPEED := 500		# Скорость пули, в пикселях * частота кадров
const BULLET_SHIFT := 9			# Сдвиг пули относительно точки спавна, в пикселях
const PUSH_FORCE := 499			# Сила, с которой пуля толкает ящик, в пикселях

var _velocity := Vector2.ZERO			# Вектор направления и скорости движения


# Двигаем пулю
func _physics_process(delta):
	_velocity = BULLET_SPEED * moving_direction
	_velocity *= delta
	
	# Проверка, с чем пуля столкнулась
	var collision: KinematicCollision2D = move_and_collide(_velocity, false)
	if collision != null:
		_check_collision(collision)


# Реакция пули при столкновении
func _check_collision(collision: KinematicCollision2D):
	var collider: Object = collision.collider
	var collider_normal: Vector2 = collision.normal
	
	if collider.has_method("destroy"):
		collider.destroy()
		destroy_bullet()
		
	elif collider.has_method("kill"):
		collider.kill()
		destroy_bullet()
		
	elif collider is Crate:
		collider.apply_force(-collider_normal.x * PUSH_FORCE, true)
		destroy_bullet()
		
	elif collider.is_in_group("bounce_blocks"):
		collider.bounce_bullet()
		rotation_degrees += 180
		moving_direction = collision.get_normal()
		
	elif collider.is_in_group("bounce_triangles"):
		collider.bounce_bullet(moving_direction)
		destroy_bullet()
		
	elif collider.is_in_group("blocks"):
		if GameData.sound_enabled:
			collider.get_node("BulletHit").play()
		destroy_bullet()
	else:
		destroy_bullet()


# Удалить пулю из сцены
func destroy_bullet() -> void:
	hide()
	queue_free()

