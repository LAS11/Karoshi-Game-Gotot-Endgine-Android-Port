extends Node2D

func _ready():
	get_tree().set_quit_on_go_back(false)
	$number.set_text("21")
	
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene("res://levels/level21.tscn")
	

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
			get_tree().change_scene("res://main_menu/main_menu.tscn")
