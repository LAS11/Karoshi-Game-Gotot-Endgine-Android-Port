extends Control
## Главный экран игры
## Сюда загружаются все сцены, отсюда происходит управление виртуальным геймпадом

signal restart_was_pressed

# Константы номеров особых уровней
const FINAL_LEVEL_NUMBER := 30
const RESTART_TRICK_LEVEL_NUMBER := 21
const PROBLEM_ASPECT_RATIO := 1.777778  # Соотношение сторон 16 / 9

onready var game_viewport: Node = get_node("%Viewport")
onready var current_scene: Node = get_node("%MainMenu")
onready var screen_aspect_ratio := OS.get_screen_size().x / OS.get_screen_size().y
onready var window_aspect_ratio := OS.get_window_size().x / OS.get_window_size().y


var level_pack := LevelPack.new()
var buttons_handler := GamepadButtonsHandler.new()
var can_restart := false
var current_level_number := -1

func _ready():
	randomize()
	
	# Если игра запущена в браузере или на ПК - скываем кнопки управления
	if OS.get_name() == "Windows":
		hide_screen_controls()
	elif OS.get_name() == "HTML5" and not is_smartphone_web():
		hide_screen_controls()
		
	# Временное (?) решение вопроса с размерами кнопок
	# для экранов с разрешением 1920х1080
	if is_equal_approx(screen_aspect_ratio, PROBLEM_ASPECT_RATIO) \
			or is_equal_approx(window_aspect_ratio, PROBLEM_ASPECT_RATIO):
		# Уменьшаем размер игрового экрана, если игра запущена на смартфоне
		if OS.get_name() == "Android" or OS.get_name() == "iOS" or is_smartphone_web():
			downscale_screen()
	
	#prints(OS.get_window_size(), window_aspect_ratio, screen_aspect_ratio, 1920.0/1080.0, 1280.0/720.0)
	
	# Задний фон игры делаем тёмно-красным - скрыает кадр, который мелькает при смене уровня
	VisualServer.set_default_clear_color(Color(0.75, 0.0, 0.0, 1.0)) 
	$Overlay/RedRect/AnimationPlayer.play("blink_screen_red")
	set_ui_buttons(false)
	set_process_unhandled_input(false)
	connect_scene()
	
	# На случай, если вместо главного меню загружен уровень
	if is_scene_a_level():
		can_restart = true
		if GameData.music_enabled:
			MusicPlayer.play()
		set_ui_buttons(true)
		set_process_unhandled_input(true)


# Отслеживаем нажатие кнопки назад на смартфоне
func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if is_scene_a_level():
			load_main_menu()
		else:
			GameData.save_data()
			get_tree().quit()


# Отслеживание нажатия кнопок перезапуска и главного меню
func _unhandled_input(_event):
	if Input.is_action_just_pressed("restart"):
		if not can_restart:
			return
		if GameData.sound_enabled:
			$RestartSound.play()
		if current_level_number == RESTART_TRICK_LEVEL_NUMBER:
			emit_signal("restart_was_pressed")
		else:
			set_process_unhandled_input(false)
			load_level(current_level_number) # Просто грузим уровень с тем же самым номером
			set_process_unhandled_input(true)
	elif Input.is_action_just_pressed("menu"):
		set_process_unhandled_input(false)
		Input.action_release("move_left")
		Input.action_release("move_right")
		Input.action_release("jump")
		Input.action_release("shoot")
		Input.action_release("restart")
		load_main_menu()


# Проверка, не запущена ли игра на смартфоне в браузере
func is_smartphone_web() -> bool:
	return JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)", true)


# Скрываем кнопки управления
func hide_screen_controls() -> void:
	get_node("%MoveLeft").hide()
	get_node("%MoveRight").hide()
	get_node("%Menu").hide()
	get_node("%Jump").hide()
	get_node("%Shoot").hide()
	get_node("%Restart").hide()


# Подгоняем размер экрана игры и положение кнопок
# под соотношение 16х9
func downscale_screen() -> void:
	yield(get_tree(), "idle_frame")
	get_node("%ViewportContainer").set_scale(Vector2(0.86, 0.86))
	
	for button in get_tree().get_nodes_in_group("gamepad_buttons"):
		match button.name:
			"MoveLeft", "MoveRight":
				button.position.x += 50
			"Jump", "Shoot":
				button.position.x -= 50
			"Menu":
				button.position.x += 50
				button.position.y += 20
			"Restart":
				button.position.x -= 50
				button.position.y += 20


func set_default_window() -> void:
	yield(get_tree(), "idle_frame")
	get_node("%ViewportContainer").set_scale(Vector2(1.0, 1.0))
	
	for button in get_tree().get_nodes_in_group("gamepad_buttons"):
		match button.name:
			"MoveLeft":
				button.position = Vector2(-163, 360)
			"MoveRight":
				button.position = Vector2(-163, 360)
			"Jump":
				button.position = Vector2(55, 364)
			"Shoot":
				button.position = Vector2(12, 288)
			"Menu":
				button.position = Vector2(-82.499, 16)
			"Restart":
				button.position = Vector2(20, 16)


# Переключение кнопок виртуального геймпада
func set_ui_buttons(enabled: bool) -> void:
	for button in get_tree().get_nodes_in_group("gamepad_buttons"):
		var action_name: String = buttons_handler.get_button_action(button.name, enabled)
		var button_texture: Texture = buttons_handler.get_button_texture(button.name, enabled)
		
		button.set_action(action_name)
		button.set_texture(button_texture)


# Подключает к отображаемому экрану сигналы
func connect_scene() -> void:
	# Сигналы, если загружено главное меню
	if not is_scene_a_level():
		# warning-ignore:return_value_discarded
		current_scene.connect("level_selected", self, "_on_level_selected")
		# warning-ignore:return_value_discarded
		current_scene.connect("about_pressed", self,  "_on_MainMenu_About_pressed")
		return
	
	# Сигналы, если загружен уровень игры
	var level_logic: Node = current_scene.get_node("LevelTemplate")
	var next_level_number: int = level_logic.level_number + 1
	# warning-ignore:return_value_discarded
	level_logic.connect("ready_to_leave", self, "load_level", [next_level_number])
	
	if current_level_number == RESTART_TRICK_LEVEL_NUMBER:
		# warning-ignore:return_value_discarded
		connect("restart_was_pressed", current_scene, "_on_restart_was_pressed")
	elif current_level_number == FINAL_LEVEL_NUMBER:
		# warning-ignore:return_value_discarded
		current_scene.connect("final_level_completed", self, "_on_final_level_completed")
		# warning-ignore:return_value_discarded
		current_scene. connect("end_screen_showed", self, "_on_EndScreen_showed")


func update_level_number() -> void:
	current_level_number = int(current_scene.get_node("LevelTemplate").level_number) if is_scene_a_level() else -1


# Проверка, является ли текущая сцена уровнем
func is_scene_a_level() -> bool:
	return current_scene.name.find("Level") != -1


# Загрузка сцены уровня номером level_number
func load_level(level_number: int) -> void:
	for scene in game_viewport.get_children():
		scene.queue_free()
		yield(scene, "tree_exited")
	yield(get_tree(), "idle_frame")

	current_scene = level_pack.get_level_instance(level_number)
	game_viewport.add_child(current_scene)
	update_level_number()
	connect_scene()
	
	if current_level_number > GameData.levels_completed:
		GameData.levels_completed = current_level_number
		GameData.save_data()


# Загрузить главное меню (Esc или нажатие кнопки "Menu")
func load_main_menu() -> void:
	GameData.save_data()
	can_restart = false
	set_ui_buttons(false)
	load_level(-1)
	MusicPlayer.stop()


## СИГНАЛЫ

func _on_MainMenu_About_pressed():
	get_node("%BackgroundAbout").show()
	get_node("%PopupAbout").popup_centered()
	game_viewport.set_disable_input(true)
	for button in get_tree().get_nodes_in_group("gamepad_buttons"):
		button.set_z_index(0)


func _on_PopupAbout_popup_hide():
	get_node("%BackgroundAbout").hide()
	game_viewport.set_disable_input(false)
	for button in get_tree().get_nodes_in_group("gamepad_buttons"):
		button.set_z_index(1)


# Срабатывает при нажатии кнопки уровня в главном меню
func _on_level_selected(level_number: int):
	load_level(level_number)
	set_ui_buttons(true)
	set_process_unhandled_input(true)
	can_restart = true
	if GameData.music_enabled:
		MusicPlayer.play()


# Срабатывает при прохождении последнего уровня
func _on_final_level_completed() -> void:
	if (OS.get_name() == "Android" or OS.get_name() == "HTML5") and GameData.vibro_enabled:
		Input.vibrate_handheld(600)
	can_restart = false
	set_process_unhandled_input(false)
	set_ui_buttons(false)
	
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")
	Input.action_release("shoot")
	Input.action_release("restart")


# Срабатывает после того, как на последнем уровне появился прощальный экран
func _on_EndScreen_showed() -> void:
	get_node("%Menu").set_texture(buttons_handler.get_button_texture("Menu", true))
	get_node("%Menu").set_action(buttons_handler.get_button_action("Menu", true))
	set_process_unhandled_input(true)


func _on_AnimationPlayer_animation_finished(_anim_name):
	$Overlay.set_visible(false)
