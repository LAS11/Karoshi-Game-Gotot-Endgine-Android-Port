extends Sprite
# Часы

signal time_finished

export var time_limit = 60


var sec_passed = 0
func _on_Timer_timeout():
	sec_passed += 1
	if GameData.sound_enabled:
		$TickSound.play()
	$Arrow.rotate(deg2rad(6))
	
	# По истечении времени что-то должно произойти
	if (sec_passed == time_limit):
		emit_signal("time_finished")
		$Timer.stop()
