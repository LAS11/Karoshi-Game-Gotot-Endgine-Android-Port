extends Node2D

func _ready():
	var file = File.new()
	file.open("user://savegame.data", File.READ_WRITE)
	var progress = file.get_as_text().to_int()
	var current_level_number = get_tree().get_current_scene().get_name().to_int()
	if progress < current_level_number:
		file.store_string(String(current_level_number))
	file.close()
	get_tree().set_quit_on_go_back(false)
	$number.set_text("10")

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func _process(delta):
	if ($player.position.x > 640):
		$part1_camera._set_current(false)
		$part2_camera._set_current(true)
	if ($player.position.x < 640):
		$part1_camera._set_current(true)
		$part2_camera._set_current(false)