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
	$number.set_text("20")

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
			get_tree().change_scene("res://main_menu/main_menu.tscn")


var giant_basket = preload("res://levels/level20/giant_basket.tscn")

func _on_Timer_timeout():
	for i in range (0, 10):
		var s = giant_basket.instance()
		add_child(s)
