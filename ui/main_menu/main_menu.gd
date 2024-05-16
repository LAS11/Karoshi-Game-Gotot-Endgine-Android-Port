extends Control

signal level_selected(level_number)
signal about_pressed


func _ready():
	for button in get_tree().get_nodes_in_group("level_buttons"):
		button.connect("pressed", self, "_on_level_pressed", [button.name])
	$RedRect/AnimationPlayer.play("fade_red")
	activate_level_buttons()
	get_node("%Music").pressed = GameData.music_enabled
	get_node("%Sound").pressed = GameData.sound_enabled
	get_node("%Vibration").pressed = GameData.vibro_enabled
	
	# Скрываем кнопку переключения вибрации, если игра запущена не на смартфоне
	if OS.get_name() != "Android":
		get_node("%Vibration").button_mask = 0
		get_node("%Vibration").self_modulate.a = 0


func activate_level_buttons() -> void:
	var level_buttons: Array = get_tree().get_nodes_in_group("level_buttons")
	
	if GameData.levels_completed > 25:
		for button in level_buttons:
			button.activate_button()
		return
	
	for button in level_buttons:
		var level_number := int(button.get_name().substr(5))
		if level_number == 0 or level_number <= GameData.levels_completed:
			button.activate_button()
		else:
			return


func _on_level_pressed(level_name: String) -> void:
	var level_number := int(level_name.substr(5))
	emit_signal("level_selected", level_number)
	

func _on_Music_toggled(button_pressed):
	GameData.music_enabled = button_pressed
	GameData.save_data()
	
	
func _on_Sound_toggled(button_pressed):
	GameData.sound_enabled = button_pressed
	GameData.save_data()


func _on_Vibration_toggled(button_pressed):
	GameData.vibro_enabled = button_pressed
	GameData.save_data()
	if button_pressed and OS.get_name() == "Android":
		Input.vibrate_handheld(100)
		
	

func _on_About_pressed():
	emit_signal("about_pressed")




