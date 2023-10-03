extends DefaultButton
# Кнопка на полу

export var blue_button := false
var bodies_inside := 0 # Кол-во тел, удерживающих кнопку нажатой

func _ready():
	if blue_button:
		$Sprite.texture.current_frame = 2


func _on_FloorButton_body_entered(_body):
	if bodies_inside == 0:
		press_button()
		$Sprite.texture.current_frame += 1
		if GameData.sound_enabled and not $ButtonPressed.is_playing():
			$ButtonPressed.play()
	bodies_inside += 1


func _on_FloorButton_body_exited(_body):
	bodies_inside -= 1
	if bodies_inside == 0:
		release_button()
		$Sprite.texture.current_frame -= 1
		if GameData.sound_enabled and not $ButtonReleased.is_playing():
			$ButtonReleased.play()
