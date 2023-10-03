extends Node2D
# Болванка уровня
# Содержит в себе базовую логику игры (например, реакция на нажатие кнопок)

signal ready_to_leave

export var can_restarted := true
export var level_number := 0

var floor_buttons_amount := 0
var crate_buttons_amount := 0

signal floor_button_pressed
signal floor_button_released


func _ready():
	# Подключаем все кнопки к болванке уровня - отслеживаем их нажатие
	var floor_buttons: Array = get_tree().get_nodes_in_group("floor_buttons")
	for button in floor_buttons:
		button.connect("pressed", self, "_on_floor_button_pressed")
		button.connect("released", self, "_on_floor_button_released")
	
	var crate_buttons: Array = get_tree().get_nodes_in_group("crate_buttons")
	for button in crate_buttons:
		button.connect("pressed", self, "_on_crate_button_pressed")
		button.connect("released", self, "_on_crate_button_released")
	
	# Записываем номер уровня в оверлей
	$Overlay.set_kills_number(str(level_number))
	
	if get_node("Overlay") != null:
		$Overlay.blink_red()


func _check_floor_buttons():
	var button_blocks: Array = get_tree().get_nodes_in_group("button_blocks")
	
	if floor_buttons_amount % 2 != 0:
		for block in button_blocks:
			if not block.is_in_group("crate_blocks"):
				block.disable_block()
	else:
		for block in button_blocks:
			if not block.is_in_group("crate_blocks"):
				block.enable_block()


func _check_crate_buttons():
	var crate_blocks: Array = get_tree().get_nodes_in_group("crate_blocks")
	
	if crate_buttons_amount % 2 != 0:
		for block in crate_blocks:
			block.disable_block()
	else:
		for block in crate_blocks:
			block.enable_block()


# Нажатие/разжатие обычной кнопки
func _on_floor_button_pressed():
	floor_buttons_amount += 1
	emit_signal("floor_button_pressed")
	_check_floor_buttons()


func _on_floor_button_released():
	floor_buttons_amount -= 1
	emit_signal("floor_button_released")
	_check_floor_buttons()


# Нажатие/разжатие кнопки, нажимаемой ящиками
func _on_crate_button_pressed():
	crate_buttons_amount += 1
	_check_crate_buttons()


func _on_crate_button_released():
	crate_buttons_amount -= 1
	_check_crate_buttons()


func _on_Player_died():
	$Overlay.fade_red()


func _on_Overlay_level_transition_finished():
	emit_signal("ready_to_leave")
