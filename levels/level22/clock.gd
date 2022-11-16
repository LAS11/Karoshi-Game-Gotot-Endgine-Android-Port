extends Sprite

const TIME_OUT = 60
var sec_pass = 0
var crate = preload("res://props/crate/crate.tscn")

func _on_Timer_timeout():
	sec_pass += 1
	$AudioStreamPlayer.play()
	$arrow.rotate(deg2rad(6))
	#по истечении 60 секунд что-то должно произойти
	if (sec_pass == TIME_OUT):
		var s = crate.instance()
		s.position = to_local(Vector2(336, -16))
		add_child(s)