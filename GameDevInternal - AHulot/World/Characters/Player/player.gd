extends CharacterBody2D

@export var SPEED: int = 100
@export var JUMP_PRESSED: int = -280
@export var JUMP_RELEASED: int = -70
@export var ACCELERATION: int = 15
@export var FRICTION: int = 15
@export var GRAVITY: int = 10
@export var ADD_FALL_GRAVITY: int = 50


enum { WANDER }

var state = WANDER
var fast_fall = false


func _ready():
	set_meta("Player", 1)


func _physics_process(_delta):	
	var input = Vector2.ZERO
	
	# Get acceleration if any:
	input.x = Input.get_axis("ui_left", "ui_right")
	
	match state:
		WANDER: wander_state(input)
	

func wander_state(input):
	apply_gravity()
	
	if input.x == 0:
		if is_on_floor():
			$AnimationPlayer.play("idle")	
		apply_friction()
		
	else:
		# Change which way the player faces:
		if input.x > 0:
			$Sprite2D.flip_h = false
		elif input.x < 0:
			$Sprite2D.flip_h = true
			
		if is_on_floor():
			$AnimationPlayer.play("walk")	
		apply_acceleration(input.x)
	
	# Only jump if player is on the ground:
	if is_on_floor():
		fast_fall = false	
		if Input.is_action_pressed("ui_up"):
			$AnimationPlayer.play("jump")
			velocity.y = JUMP_PRESSED
	else:
		# Allows player jump height to change:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASED:
			velocity.y = JUMP_RELEASED
		
		# Make character fall faster after jumping:
		if velocity.y > 0 and not fast_fall:
			velocity.y += ADD_FALL_GRAVITY
			fast_fall = true
	
	if Input.is_action_pressed("ui_left_click"):
		var mouse = get_global_mouse_position()
		var player = get_node("/root/World/Player").position

		if mouse.x > player.x:
			$Sprite2D.flip_h = false
		elif mouse.x < player.x:
			$Sprite2D.flip_h = true
		
		$AnimationPlayer.stop()
		$AnimationPlayer.play("shoot")
	
	move_and_slide()

func apply_gravity():
	velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)

