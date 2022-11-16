extends StaticBody2D

export var debug = false

func cast_to_player(x, y):
	$RayCast2D.set_cast_to(to_local(Vector2(x, y)))

func get_cast_to_player():
	$RayCast2D.get_cast_to()