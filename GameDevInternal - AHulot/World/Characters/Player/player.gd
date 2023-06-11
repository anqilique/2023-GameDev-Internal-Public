extends CharacterBody2D

@export var SPEED: int = 100
@export var JUMP_PRESSED: int = -280
@export var JUMP_RELEASED: int = -70
@export var ACCELERATION: int = 15
@export var FRICTION: int = 15
@export var GRAVITY: int = 10
@export var ADD_FALL_GRAVITY: int = 50
@export var MAX_ENERGY : int = 100
@export var shoot_energy : int = 2
@export var jump_energy : int = 1

enum { WANDER, SHOOT, DEAD }

var spawn_point = Vector2.ZERO
var state = WANDER
var is_alive = true
var fast_fall = false
var is_shooting = false
var bulletspawn_pos
var energy


func _ready():
	var energybar = get_node("/root/World/UI/Stats/EnergyBar")
	
	energy = MAX_ENERGY
	energybar.max_value = MAX_ENERGY
	
	spawn_point = global_position


func _physics_process(_delta):	
	var input = Vector2.ZERO
	
	# Get acceleration if any:
	input.x = Input.get_axis("ui_left", "ui_right")
	
	match state:
		WANDER: wander_state(input)
		SHOOT: shoot_state()
		DEAD: dead_state()
	
	bulletspawn_pos = $Sprite2D.position.x - $BulletSpawn.position.x
		
	if bulletspawn_pos < 0:
		$BulletSpawn.position.x += bulletspawn_pos
	
	if !is_alive:
		state = DEAD
		
	$HealthComponent.update_battlehealth()
	update_stats("health")
	update_stats("energy")

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
	
	# Only jump if player is on the ground and if there's enough energy
	if is_on_floor() and energy >= jump_energy:
		fast_fall = false	
		if Input.is_action_pressed("ui_up"):
			$AnimationPlayer.play("jump")
			velocity.y = JUMP_PRESSED
			energy -= jump_energy
	else:
		# Allows player jump height to change:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASED:
			velocity.y = JUMP_RELEASED
		
		# Make character fall faster after jumping:
		if velocity.y > 0 and not fast_fall:
			velocity.y += ADD_FALL_GRAVITY
			fast_fall = true
	
	if Input.is_action_just_pressed("ui_left_click"):
		if energy >= shoot_energy:
			is_shooting = true
			state = SHOOT
	
	move_and_slide()

func shoot_state():
	apply_gravity()
	move_and_slide()
	
	velocity.x = 0
	
	var mouse = get_global_mouse_position()

	if mouse.x > position.x:
		$Sprite2D.flip_h = false
		$Sprite2D.flip_h = false
	elif mouse.x < position.x:
		$Sprite2D.flip_h = true
		
	$AnimationPlayer.play("shoot")
	
	if Input.is_action_just_released("ui_left_click"):
		is_shooting = false
		state = WANDER

func update_stats(stat):
	if stat == "health":
		var health = get_node("HealthComponent").health
		var MAX_HEALTH = get_node("HealthComponent").MAX_HEALTH
		var healthbar = get_node("/root/World/UI/Stats/HealthBar")
		var healthtext = get_node("/root/World/UI/Stats/HealthBar/HealthText")
		
		if state != DEAD:
			healthbar.value = health
			healthtext.text = str(health) + " / " + str(MAX_HEALTH)
		else:
			healthbar.value = 0
			healthtext.text = str(health) + " / " + str(MAX_HEALTH)

	if stat == "energy":
		var energybar = get_node("/root/World/UI/Stats/EnergyBar")
		var energytext = get_node("/root/World/UI/Stats/EnergyBar/EnergyText")
		
		energybar.value = energy
		energytext.text = str(energy) + " / " + str(MAX_ENERGY)

func regenerate():
	var flame_state = get_node("/root/World/Camp").flame_state
	
	if energy < MAX_ENERGY:
		var add_energy = flame_state
		if (energy + add_energy) > MAX_ENERGY:
			energy = MAX_ENERGY
		else:
			energy += add_energy
	
	$HealthComponent.regen_health()

func dead_state():
	var health = get_node("HealthComponent").health
	var MAX_HEALTH = get_node("HealthComponent").MAX_HEALTH
	energy = 0
		
	self.hide()
	
	if Input.is_action_just_pressed("ui_interact"):
		energy = 0.1 * MAX_ENERGY
		state = WANDER
		
		$HealthComponent.respawn()
		
		is_alive = true
	
		self.show()

func apply_gravity():
	velocity.y += GRAVITY	

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)
