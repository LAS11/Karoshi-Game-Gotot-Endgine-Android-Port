extends Node2D
# Конечности главного героя (разлетаются при смерти)


func explode(has_wings := false) -> void:
	# Показываем отлетающие крылья в зависимости от того, есть ли они у игрока
	$Gibs/LeftWing.visible = has_wings
	$Gibs/RightWing.visible = has_wings
	
	for node in $Gibs.get_children():
		# warning-ignore:unassigned_variable
		var push_force: Vector2
		push_force.x = (randi() % 500 + 200) * _calc_push_direcion()
		push_force.y = (randi() % 500 + 200) * _calc_push_direcion()
		
		node.set_mode(node.MODE_RIGID)
		node.apply_impulse(Vector2(0, 0), push_force)
		node.add_torque(1500)
	
	for node in $Particles.get_children():
		node.restart()


# Сгенерировать 1 или -1 - используется для определения направления полёта конечности
func _calc_push_direcion() -> int:
	if randi() % 2 == 1:
		return 1
	return -1
