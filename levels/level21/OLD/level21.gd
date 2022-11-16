extends Node2D

var restart = 0
var current_scene
var current_scene_number

func _ready():
	save_game()
	get_node("spikes2").hide()
	for i in range (1, 10):
		get_node("spikes2/spike" + String(i)).set_monitoring(false)
	
	current_scene = get_tree().get_current_scene()
	current_scene_number = get_tree().get_current_scene().get_name().to_int()


func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		$player.set_position(Vector2(304, 160))
		restart += 1
		restart_level(restart)


func restart_level(restart):
	print(restart)
	get_node("spikes2").hide()
	get_node("spikes1").hide()
	for i in range (1, 10):
		get_node("spikes2/spike" + String(i)).set_monitoring(false)
	for i in range (1, 11):
		get_node("spikes1/spike" + String(i)).set_monitoring(false)
	
	if ($player.position == Vector2(304, 160)):
		if (restart < 1) or (restart % 2 == 1):
			get_node("spikes1").show()
			for i in range (1, 11):
				get_node("spikes1/spike" + String(i)).set_monitoring(true)
		elif (restart % 2 == 0):
			get_node("spikes2").show()
			for i in range (1, 10):
				get_node("spikes2/spike" + String(i)).set_monitoring(true)

func save_game():
	var file = File.new()
	file.open("user://savegame.data", File.READ_WRITE)
	var progress = file.get_as_text().to_int()
	var current_level_number = get_tree().get_current_scene().get_name().to_int()
	if progress < current_level_number:
		file.store_string(String(current_level_number))
	file.close()