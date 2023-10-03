extends DefaultButton
# Кнопка, нажимаемая только ящиками


func _on_CrateButton_pressed(_body):
	if pressed:
		return
	press_button()
	$Sprite.texture.current_frame = 1
	if GameData.sound_enabled:
		$ButtonPressed.play()


func _on_CrateButton_released(_body):
	if not pressed:
		return
	release_button()
	$Sprite.texture.current_frame = 0
