extends KinematicBody2D

const BULLET_SPEED = 500
const BULLET_SHIFT = 9
const FLOOR_NORMAL = Vector2(0, -1)
const PUSH_FORCE = 250

var bullet_velocity = Vector2()
var horizontal = true
var vertical = false
var is_bullet = true

func _physics_process(delta):
	#var transform = Transform2D(self.get_rotation(), self.get_position())
	
	if (get_slide_count() != 0):
		for i in range(0, get_slide_count()):
			var collision = get_slide_collision(i).get_collider()
			var collision_normal = get_slide_collision(i).get_normal()
			#var collision_travel = get_slide_collision(i).get_travel()
			#var collision_remaider = get_slide_collision(i).get_remainder()
			# значение угла столкновения округляется 
			var collision_angle = round(rad2deg(collision_normal.angle()))

			# код для проверки всех сценариев столкновения
			# пули с отражающими поверхностями
			# break используется для предотвращения
			# повторного прохождения цикла при столкновении
			if collision.is_in_group("bounce_blocks"):
				if (collision_normal == Vector2.LEFT):
					flip_bullet_sprite('h')
					bullet_velocity.x = -BULLET_SPEED
				elif (collision_normal == Vector2.RIGHT):
					flip_bullet_sprite('h')
					bullet_velocity.x = BULLET_SPEED
				elif (collision_normal == Vector2.UP):
					flip_bullet_sprite('v')
					bullet_velocity.y = BULLET_SPEED
				elif (collision_normal == Vector2.DOWN):
					flip_bullet_sprite('v')
					bullet_velocity.y = -BULLET_SPEED
			elif collision.is_in_group("bounce_block_LUp"):
				if (collision_angle == -135):
					if (horizontal):
						position.x = collision.position.x
						position.y = collision.position.y - BULLET_SHIFT
						bullet_velocity.x = 0
						bullet_velocity.y = -BULLET_SPEED
						horizontal = false
						vertical = true
						break
					elif (vertical):
						position.x = collision.position.x - BULLET_SHIFT
						position.y = collision.position.y
						bullet_velocity.x = -BULLET_SPEED
						bullet_velocity.y = 0
						vertical = false
						horizontal = true
						break
				# случай, если солкновение не с гипотенузой треугольника
				else:
					if (collision_normal == Vector2.RIGHT):
						flip_bullet_sprite('h')
						bullet_velocity.x = BULLET_SPEED
					elif (collision_normal == Vector2.DOWN):
						flip_bullet_sprite('v')
						bullet_velocity.y = -BULLET_SPEED
			elif collision.is_in_group("bounce_block_LDown"):
				if (collision_angle == 135):
					if(horizontal):
						position.x = collision.position.x
						position.y = collision.position.y + BULLET_SHIFT
						bullet_velocity.x = 0
						bullet_velocity.y = BULLET_SPEED
						horizontal = false
						vertical = true
						break
					elif (vertical):
						position.x = collision.position.x - BULLET_SHIFT
						position.y = collision.position.y
						bullet_velocity.x = -BULLET_SPEED
						bullet_velocity.y = 0
						horizontal = true
						vertical = false
						break
				else:
					if (collision_normal == Vector2.RIGHT):
						flip_bullet_sprite('h')
						bullet_velocity.x = BULLET_SPEED
					elif (collision_normal == Vector2.UP):
						flip_bullet_sprite('v')
						bullet_velocity.y = -BULLET_SPEED
			elif collision.is_in_group("bounce_block_RUp"):
				if (collision_angle == -45):
					if(horizontal):
						position.x = collision.position.x
						position.y = collision.position.y - BULLET_SHIFT
						bullet_velocity.x = 0
						bullet_velocity.y = -BULLET_SPEED
						horizontal = false
						vertical = true
						break
					elif (vertical):
						position.x = collision.position.x + BULLET_SHIFT
						position.y = collision.position.y
						bullet_velocity.x = BULLET_SPEED
						bullet_velocity.y = 0
						horizontal = true
						vertical = false
						break
				else:
					if (collision_normal == Vector2.LEFT):
						flip_bullet_sprite('h')
						bullet_velocity.x = -BULLET_SPEED
					elif (collision_normal == Vector2.DOWN):
						flip_bullet_sprite('v')
						bullet_velocity.y = BULLET_SPEED
			elif collision.is_in_group("bounce_block_RDown"):
				if (collision_angle == 45):
					if(horizontal):
						position.x = collision.position.x
						position.y = collision.position.y + BULLET_SHIFT
						bullet_velocity.x = 0
						bullet_velocity.y = BULLET_SPEED
						horizontal = false
						vertical = true
						break
					elif (vertical):
						position.x = collision.position.x + BULLET_SHIFT
						position.y = collision.position.y
						bullet_velocity.x = BULLET_SPEED
						bullet_velocity.y = 0
						horizontal = true
						vertical = false
						break
				else:
					if (collision_normal == Vector2.LEFT):
						flip_bullet_sprite('h')
						bullet_velocity.x = -BULLET_SPEED
					elif (collision_normal == Vector2.UP):
						flip_bullet_sprite('v')
						bullet_velocity.y = -BULLET_SPEED
			else:
				if collision.has_method("destroy"):
					collision.destroy()
					queue_free()
				if (collision.get_name() == "boss"):
					if (collision.on_ground == false):
						collision.fall()
					queue_free()
				if collision.is_in_group("crates"):
					if collision_normal == Vector2.RIGHT:
						collision.velocity.x = -PUSH_FORCE
					elif collision_normal == Vector2.LEFT:
						collision.velocity.x = PUSH_FORCE
					queue_free()
				if collision.is_in_group("geometry"):
					queue_free()
				if collision.get_name() == "level_border":
					queue_free()
	if ($RayCast2D.get_collider()):
		if ($RayCast2D.get_collider().get_name() == "player"):
			$RayCast2D.get_collider().kill()
			
	bullet_velocity = move_and_slide(bullet_velocity, FLOOR_NORMAL)

func flip_bullet_sprite(dir):
	if (dir == 'h'):
		if ($Sprite.is_flipped_h()):
			$Sprite.set_flip_h(false)
		else:
			$Sprite.set_flip_h(true)
	elif (dir == 'v'):
		if ($Sprite.is_flipped_v()):
			$Sprite.set_flip_v(false)
		else:
			$Sprite.set_flip_v(true)