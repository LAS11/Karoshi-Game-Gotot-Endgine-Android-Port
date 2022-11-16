extends Control

var progress

func _ready():
	get_tree().set_quit_on_go_back(true)
	var file = File.new()
	if file.file_exists("user://savegame.data"):
		file.open("user://savegame.data", File.READ)
		progress = file.get_as_text().to_int()
		print(progress)
		$Label.set_text("you completed " + String(progress) + " levels")
	else:
		print("no save, creating one...")
		file.open("user://savegame.data", File.WRITE)
		file.store_string("0")
		progress = 0
	file.close()

func _on_Button_pressed():
	var levelNumber = $SpinBox.get_line_edit().text.to_int()
	if (levelNumber > -1) and (levelNumber < 31) and (levelNumber <= progress):
		get_tree().change_scene("res://levels/level" + String(levelNumber) + ".tscn")
