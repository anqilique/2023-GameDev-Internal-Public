extends CharacterBody2D

@export var SPEED: int = 100
@export var JUMP_PRESSED: int = -280
@export var JUMP_RELEASED: int = -70
@export var ACCELERATION: int = 15
@export var FRICTION: int = 15
@export var GRAVITY: int = 10
@export var ADD_FALL_GRAVITY: int = 50

enum { WANDER, SHOOT }

var state = WANDER
var fast_fall = false
var is_shooting = false
var bulletspawn_pos


func _ready():
	pass


func _physics_process(_delta):	
	var input = Vector2.ZERO
	
	# Get acceleration if any:
	input.x = Input.get_axis("ui_left", "ui_right")
	
	match state:
		WANDER: wander_state(input)
		SHOOT: shoot_state()
	
	bulletspawn_pos = $Sprite2D.position.x - $BulletSpawn.position.x
		
	if bulletspawn_pos < 0:
		$BulletSpawn.position.x += bulletspawn_pos
	

func wander_state(input):
	apply_gravity()
	
	if input.x == 0:
		if is_on_floor() and not is_shooting:
			$AnimationPlayer.play("idle")	
		apply_friction()
		
	else:
		# Change which way the player faces:
		if input.x > 0:
			$Sprite2D.flip_h = false
		elif input.x < 0:
			$Sprite2D.flip_h = true
			
		if is_on_floor():
			if $AnimationPlayer.current_animation != "walk":
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
	
	if Input.is_action_just_pressed("ui_left_click"):
		is_shooting = true
		state = SHOOT
		print(position)
	
	move_and_slide()

func shoot_state():
	apply_gravity()
	move_and_slide()
	
	var mouse = get_global_mouse_position()

	if mouse.x > position.x:
		$Sprite2D.flip_h = false
	elif mouse.x < position.x:
		$Sprite2D.flip_h = true
		
	$AnimationPlayer.play("shoot")
	
	if Input.is_action_just_released("ui_left_click"):
		is_shooting = false
	
		state = WANDER
	

func apply_gravity():
	velocity.y += GRAVITY	

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)
