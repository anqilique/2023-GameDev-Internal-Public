extends CharacterBody2D

@export var SPEED : int = 80
@export var JUMP_PRESSED : int = -180
@export var JUMP_RELEASED : int = -70
@export var ACCELERATION : int = 15
@export var FRICTION : int = 15
@export var GRAVITY : int = 10
@export var ADD_FALL_GRAVITY : int = 50
@export var MAX_ENERGY : int = 100
@export var shoot_energy : int = 2
@export var jump_energy : int = 1
@export var jump_max : int = 1

enum { WANDER, CLIMB, SHOOT, DEAD }

var collected_parts = {
	0 : 0,
	1 : 0,
	2 : 0
}

var spawn_point = Vector2.ZERO
var state = WANDER
var jump_count = 0
var is_alive = true
var fast_fall = false
var is_shooting = false
var can_jump = true
var bulletspawn_pos
var energy
var on_ladder = false


func _ready():
	var energybar = get_node("/root/World/UI/Stats/EnergyBar")
	
	energy = MAX_ENERGY
	energybar.max_value = MAX_ENERGY
	
	spawn_point = global_position
	
	$Alert.hide()


func _physics_process(_delta):	
	var input = Vector2.ZERO
	
	# Get acceleration if any:
	input.x = Input.get_axis("ui_left", "ui_right")
	
	match state:
		WANDER: wander_state(input)
		CLIMB: climb_state(input)
		SHOOT: shoot_state()
		DEAD: dead_state()
	
	bulletspawn_pos = $Sprite2D.position.x - $BulletSpawn.position.x
		
	if bulletspawn_pos < 0:
		$BulletSpawn.position.x += bulletspawn_pos
	
	if !is_alive:
		state = DEAD
	
	if energy < jump_energy:
		can_jump = false
	else:
		can_jump = true
	
	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count += 1
	
	if on_ladder and not is_on_floor():
		state = CLIMB
	
	if $Alert.is_visible():
		if $AlertTimer.is_stopped():
			$AlertTimer.start()
		
	$HealthComponent.update_battlehealth()
	update_stats("health")
	update_stats("energy")


func wander_state(input):
	apply_gravity()
	
	if input.x == 0:
		if is_on_floor() and not is_shooting:
			$AnimationPlayer.play("idle")
		
		if $IdleRegen.is_stopped() and Input.is_action_pressed("ui_down"):
			$IdleRegen.start()

		apply_friction()
		
	else:
		$IdleRegen.stop()
		
		# Change which way the player faces:
		if input.x > 0:
			$Sprite2D.flip_h = false
		elif input.x < 0:
			$Sprite2D.flip_h = true
			
		if is_on_floor():
			if $AnimationPlayer.current_animation != "walk":
				$AnimationPlayer.play("walk")
		apply_acceleration(input.x)
	
	# If player has enough energy to jump
	if can_jump:
		fast_fall = false
		
		$CanJump.start()
		
		if (jump_count < jump_max):
			if Input.is_action_just_pressed("ui_up"):
				$AnimationPlayer.play("jump")
				jump_count += 1
				
				if is_on_floor():
					velocity.y = JUMP_PRESSED
				else:  # Double jump
					velocity.y = JUMP_PRESSED + 40
					energy -= jump_energy
				
				if is_on_wall_only():  # Wall jump
					var wall_norm = get_wall_normal()
					velocity.x = wall_norm.x * JUMP_PRESSED
					
					
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


func climb_state(input):
	var dir
	
	if not on_ladder:
		state = WANDER
	
	else:
		if (
			Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")
			or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
		):
			$AnimationPlayer.play("walk")  # "climb" when animation is made.
		else:
			$AnimationPlayer.play("idle")
		
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			if Input.is_action_pressed("ui_up"):
				dir = -1
			elif Input.is_action_pressed("ui_down"):
				dir = 1
			else:
				dir = 0
			
			velocity.y = move_toward(velocity.y, SPEED/2 * dir, ACCELERATION)
			
		else:
			velocity.y = move_toward(velocity.y, 0, FRICTION)
			
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			apply_acceleration(input.x)


	move_and_slide()
	apply_friction()


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
		
		if energy > MAX_ENERGY:
			energy = MAX_ENERGY


func regenerate(nearest_camp):
	if nearest_camp.flame_state > 0:
		if energy < MAX_ENERGY:
			var add_energy = nearest_camp.flame_state
			if (energy + add_energy) > MAX_ENERGY:
				energy = MAX_ENERGY
			else:
				energy += add_energy


func find_nearest_camp():
	var camps = get_tree().get_nodes_in_group("Camps")
	var camp_distances = []
	var nearest
	
	for camp in camps:
		var dist = camp.global_position.distance_squared_to(global_position)

		if dist > 0: 
			camp_distances.append(dist)
	
	nearest = camps[camp_distances.find(camp_distances.min())]
	
	return nearest
	

func collect_orb(type):
	var orbs = get_node("/root/World/Orbs")
	if type == "Health":
		$HealthComponent.health_orb()
	elif type == "Energy":
		energy += orbs.orb_energy


func dead_state():
	energy = 0
		
	self.hide()
	
	if Input.is_action_just_pressed("ui_interact"):
		energy = 0.1 * MAX_ENERGY
		state = WANDER
		
		$HealthComponent.respawn()
		
		is_alive = true
	
		self.show()


func hit_state():
	var force
	if is_on_floor():
		force = 50
	else:
		force = 25
	
	velocity.y -= (GRAVITY + force)
	move_and_slide()


func apply_gravity():
	velocity.y += GRAVITY


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)


func _on_can_jump_timeout():
	if energy >= jump_energy:
		can_jump = true


func _on_idle_regen_timeout():
	if energy < MAX_ENERGY:
			var add_energy = 1
			if (energy + add_energy) > MAX_ENERGY:
				energy = MAX_ENERGY
			else:
				energy += add_energy


func _on_alert_timer_timeout():
	$Alert.hide()


func _on_ladder_checker_body_entered(body):
	on_ladder = true
	print(on_ladder)


func _on_ladder_checker_body_exited(body):
	on_ladder = false
	print(on_ladder)
