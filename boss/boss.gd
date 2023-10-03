class_name Boss
extends KinematicBody2D

signal died
signal landed

const JUMP_HIGHT := 1050
const MOVE_SPEED := 245

var jump1 = preload("res://player/player_jump1.wav")
var jump2 = preload("res://player/player_jump2.wav")
var jump3 = preload("res://player/player_jump3.wav")

var gravity: float = ProjectSettings.get_setting("gameplay/gravity_scale") + 10
var floor_normal: Vector2 = ProjectSettings.get_setting("gameplay/floor_normal")
var is_jumping := false
var is_flying := false setget set_flying
var moving_direction := 1 # Флаг направления движения 

var velocity: Vector2


func _physics_process(_delta):
	velocity.y += gravity
	
	if is_on_wall():
		moving_direction = -moving_direction
		
	if is_jumping:
		velocity.x = -MOVE_SPEED * moving_direction
		if is_on_floor():
			velocity.y -= JUMP_HIGHT
			if GameData.sound_enabled:
				_select_jump_sound()
				$JumpSound.play()
			
	elif is_flying:
		velocity.x = -MOVE_SPEED * moving_direction
	else:
		velocity.x = 0

	var anim_name: String = "default" if velocity.x == 0 else "angry"
	$AnimatedSprite.play(anim_name)
	
	$PlayerDetector.monitoring = not is_on_floor()
	velocity = move_and_slide(velocity, floor_normal)
	
	for i in get_slide_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		
		if collision == null:
			break
		
		if collision.collider.is_in_group("blocks") and collision.normal == floor_normal:
			emit_signal("landed")


func kill() -> void:
	emit_signal("died")


func _select_jump_sound() -> void:
	match randi() % 3:
		0:
			$JumpSound.stream = jump1
		1:
			$JumpSound.stream = jump2
		2:
			$JumpSound.stream = jump3


func set_flying(value: bool) -> void:
	is_flying = value
	
	gravity = 0 if is_flying else ProjectSettings.get_setting("gameplay/gravity_scale")
	$Flame.visible = is_flying
	if GameData.sound_enabled:
		$EngineSound.playing = is_flying
	
	if $Flame.visible:
		$Flame.play("default")
	

func _on_PlayerDetector_body_entered(body):
	if body.has_method("kill"):
		body.call_deferred("kill")
