extends KinematicBody2D

const SPEED = 300
const JUMP_HEIGHT = 1250
const GRAVITY = 85
const FLOOR_NORMAL = Vector2(0, -1)
var velocity = Vector2()
var in_air = false
var current_level_number
var can_jump

var restart_pressed
var exit_pressed
var left_pressed
var right_pressed

func _on_Area2D_body_entered(body):
	if (body.get_name() == "player"):
		body.kill()
		
func _notification(what):   
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) or (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if (current_level_number != 12):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func _ready():
	current_level_number = get_tree().get_current_scene().get_name().to_int()
	if (current_level_number == 26):
		set_physics_process(false)
		velocity = Vector2(-SPEED, 0)
	if (current_level_number == 27 or current_level_number == 28):
		set_physics_process(false)
		velocity = Vector2(-SPEED, -1445)
	set_process(false)

func _process(delta):
	exit_pressed = Input.is_action_pressed("exit")
	if exit_pressed:
		if (OS.get_name() == "Windows"):
			get_tree().quit()
		elif (OS.get_name() == "Android"):
			get_tree().change_scene("res://main_menu/main_menu.tscn")

func _physics_process(delta):
	if (velocity.y != 0):
		in_air = true
	else:
		in_air = false
	
	restart_pressed = Input.is_action_pressed("restart")
	exit_pressed = Input.is_action_pressed("exit")
	left_pressed = Input.is_action_pressed("ui_left")
	right_pressed = Input.is_action_pressed("ui_right")
	velocity.y += GRAVITY
	if restart_pressed:
		get_tree().reload_current_scene()
	if exit_pressed:
		get_tree().quit()
	if left_pressed:
		velocity.x = -SPEED
	elif right_pressed:
		velocity.x = SPEED
	else:
		velocity.x = 0

	if (Input.is_action_pressed("ui_jump")):
		Input.action_release("ui_jump")
		if ((not in_air) and can_jump):
			velocity.y = -JUMP_HEIGHT
	can_jump = not Input.is_action_pressed("ui_jump")

	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func kill():
	self.hide()
	set_physics_process(false)
	set_process(true)
	$explode/AnimatedSprite.show()
	$explode/AnimatedSprite.play("explode")
	$ui/overlay.hide()
	$ui/buttons.hide()
	$ui/logo.hide()
	$ui/kills.hide()

func _on_Area2D_area_entered(area):
	if area.get_name() == "player_doll":
		area.kill()