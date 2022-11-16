extends Node2D

var crate = preload("res://props/crate/crate.tscn")
var is_button_pressed = false

func _ready():
	var file = File.new()
	file.open("user://savegame.data", File.READ_WRITE)
	var progress = file.get_as_text().to_int()
	var current_level_number = get_tree().get_current_scene().get_name().to_int()
	if progress < current_level_number:
		file.store_string(String(current_level_number))
	file.close()
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	$number.set_text("12")

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		print(is_button_pressed)
		if (is_button_pressed == false): 
			spawn_giant_crate()
			is_button_pressed = true

func spawn_giant_crate():
	var s = crate.instance()
	s.set_position(Vector2(320, -330))
	s.set_scale(Vector2(20, 20))
	call_deferred("add_child", s)
	
func _unhandled_key_input(event):
	if (Input.is_key_pressed(75)) and (is_button_pressed == false):
		spawn_giant_crate()
		is_button_pressed = true
