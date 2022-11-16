extends Node2D

var opacity

func _ready():
	var file = File.new()
	file.open("user://savegame.data", File.READ_WRITE)
	var progress = file.get_as_text().to_int()
	var current_level_number = get_tree().get_current_scene().get_name().to_int()
	if progress < current_level_number:
		file.store_string(String(current_level_number))
	file.close()
	get_tree().set_quit_on_go_back(false)
	$number.set_text("27")

func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func _process(delta):
	if (($player.position.x > 218) and ($boss.is_physics_processing() == false)):
		$boss.set_physics_process(true)
		$boss/fire.show()
		$boss/AnimatedSprite.play("waka_waka")
		
	for i in get_tree().get_nodes_in_group("hidden_bricks"):
		var distance_to_player = round((i.get_global_position().distance_to($player.get_global_position())))-16
		var block_a = i.get_modulate().a8
		if distance_to_player <= 0:
			opacity = 255
		elif distance_to_player >= 96:
			opacity = 0
		else:
			opacity = -255/96*distance_to_player + 255
		
		i.modulate.a8 = opacity