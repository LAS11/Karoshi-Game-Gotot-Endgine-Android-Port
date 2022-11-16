extends Node

var pressed_Abuttons = 0
var pressed_Bbuttons = 0

func _ready():
	var file = File.new()
	file.open("user://savegame.data", File.READ_WRITE)
	var progress = file.get_as_text().to_int()
	var current_level_number = get_tree().get_current_scene().get_name().to_int()
	if progress < current_level_number:
		file.store_string(String(current_level_number))
#		print("writing save...")
#	else:
#		print("not writing save...")
	file.close()
	get_tree().set_quit_on_go_back(false)
	$number.set_text(get_tree().get_current_scene().get_name())

func _physics_process(delta):
	if (pressed_Abuttons % 2 == 0):
		get_tree().call_group("bricksA", "enable_brick")
	elif (pressed_Abuttons % 2 == 1):
		get_tree().call_group("bricksA", "disable_brick")
	
	if (pressed_Bbuttons % 2 == 0):
		get_tree().call_group("bricksB", "enable_brick")
	elif (pressed_Bbuttons % 2 == 1):
		get_tree().call_group("bricksB", "disable_brick")
