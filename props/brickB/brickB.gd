extends StaticBody2D

var count = 0

func _ready():
	set_physics_process(false)

func disable_brick():
	$CollisionShape2D.set_disabled(true)
	set_modulate(Color(1, 1, 1, 0))
	
func enable_brick():
	$Area2D.set_monitoring(true)
	set_physics_process(true)

func _physics_process(delta):
	if count == 0:
		$CollisionShape2D.set_disabled(false)
		$Area2D.set_monitoring(false)
		set_modulate(Color(1, 1, 1, 1))
		set_physics_process(false)
	else:
		set_modulate(Color(1, 1, 1, 0.27))

func _on_Area2D_body_entered(body):
	count += 1

func _on_Area2D_body_exited(body):
	count -= 1
