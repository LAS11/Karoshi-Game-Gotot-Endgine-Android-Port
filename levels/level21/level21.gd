extends Node2D

func _ready():
	save_game()

func _process(delta):
	#print(restart_counter.restart)
	if Input.is_action_just_pressed("restart"):
		if (restart_counter.restart == 1):
			$player.set_position(Vector2(304, 160))
		else:
			get_tree().change_scene("res://levels/level21a.tscn")
	get_tree().set_quit_on_go_back(false)
	$number.set_text("21")

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func save_game():
	var file = File.new()
	file.open("user://savegame.data", File.READ_WRITE)
	var progress = file.get_as_text().to_int()
	var current_level_number = get_tree().get_current_scene().get_name().to_int()
	if progress < current_level_number:
		file.store_string(String(current_level_number))
	file.close()
