extends Node2D

var trigger_counter = 0
var pressed_Abuttons = 0
var pressed_Bbuttons = 0
var pressed = false

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
	$number.set_text("5")
	

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func _process(delta):
	if (trigger_counter == 2) and (pressed == true):
		get_tree().call_group("electro_bricks", "activate_brick")
		$crate.electrified = true
		$crate/Sprite.set_animation("electro")
		$crate2.electrified = true
		$crate2/Sprite.set_animation("electro")
		$crate4.electrified = true
		$crate4/Sprite.set_animation("electro")
		$sparks.show()

func _physics_process(delta):
	if (pressed_Abuttons % 2 == 0):
		get_tree().call_group("bricksA", "enable_brick")
	elif (pressed_Abuttons % 2 == 1):
		get_tree().call_group("bricksA", "disable_brick")
	
	if (pressed_Bbuttons % 2 == 0):
		get_tree().call_group("bricksB", "enable_brick")
	elif (pressed_Bbuttons % 2 == 1):
		get_tree().call_group("bricksB", "disable_brick")


func _on_trigger_zones_body_entered(body):
	if body.is_in_group("crates"):
		trigger_counter += 1

func _on_trigger_zones_body_exited(body):
	if body.is_in_group("crates"):
		trigger_counter -= 1