extends CharacterBody2D

@export var SPEED : int = 80
@export var JUMP_PRESSED : int = -180
@export var JUMP_RELEASED : int = -70
@export var ACCELERATION : int = 15
@export var FRICTION : int = 15
@export var GRAVITY : int = 10
@export var ADD_FALL_GRAVITY : int = 50
@export var IDLE_ENERGY_REGEN : int = 1
@export var shoot_energy : int = 2
@export var jump_energy : int = 1
@export var jump_max : int = 1

enum { WANDER, CLIMB, SHOOT, DEAD }

var state = WANDER
var jump_count = 0
var is_alive = true
var fast_fall = false
var is_shooting = false
var can_jump = true
var bulletspawn_pos
var on_ladder = false


func _ready():
	var energybar = get_node("/root/World/UI/Stats/EnergyBar")
	energybar.max_value = player_vars.max_energy
	
	var healthbar = get_node("/root/World/UI/Stats/HealthBar")
	healthbar.max_value = player_vars.max_health
	
	global_position = player_vars.spawn_point
	
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
	
	var mouse = get_global_mouse_position()
	
	# 62-70, Change which way the player faces.
	
	if input.x > 0 and !is_shooting:
		$Sprite2D.flip_h = false
	elif input.x < 0 and !is_shooting:
		$Sprite2D.flip_h = true
	else:
		if mouse.x > position.x:
			$Sprite2D.flip_h = false
		elif mouse.x < position.x:
			$Sprite2D.flip_h = true
	
	if player_vars.energy < jump_energy:
		can_jump = false
	else:
		can_jump = true
	
	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count += 1
	
	if on_ladder and not is_on_floor():
		state = CLIMB
	
	# Floating text shows for certain time.
	if $Alert.is_visible():  
		if $AlertTimer.is_stopped():
			$AlertTimer.start()
	
	update_stats("health")
	update_stats("energy")


func wander_state(input):
	if player_vars.health > 0:  # If not dead...
		
		apply_gravity()
		
		if input.x == 0:
			if is_on_floor() and not is_shooting:
				$AnimationPlayer.play("idle")
			
			if $IdleRegen.is_stopped():
				$IdleRegen.start()

			apply_friction()
			
		else:
			$IdleRegen.stop()
				
			if is_on_floor():
				if $AnimationPlayer.current_animation != "walk":
					$AnimationPlayer.play("walk")
			apply_acceleration(input.x)
		
		# If player has enough energy to jump...
		if can_jump:
			fast_fall = false
			
			$CanJump.start()
			
			# Is able to jump at least once...
			if (jump_count < jump_max):
				if Input.is_action_just_pressed("ui_up"):
					$AnimationPlayer.play("jump")
					jump_count += 1
					
					if is_on_floor():
						velocity.y = JUMP_PRESSED
					else:  # Double jump
						velocity.y = JUMP_PRESSED + 40
						player_vars.energy -= jump_energy
					
					if is_on_wall_only():  # Wall jump
						var wall_norm = get_wall_normal()
						velocity.x = wall_norm.x * JUMP_PRESSED
						
					# Player loses energy.
					player_vars.energy -= jump_energy

		else:
			# Allows player jump height to change:
			if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASED:
				velocity.y = JUMP_RELEASED
			
			# Make character fall faster after jumping:
			if velocity.y > 0 and not fast_fall:
				velocity.y += ADD_FALL_GRAVITY
				fast_fall = true
		
		# Change state to shoot.
		if Input.is_action_just_pressed("ui_left_click"):
			if player_vars.energy >= shoot_energy:
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
			
			# Climb up/down.
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
	
	$AnimationPlayer.play("shoot")
	
	# Return to this state when stopping shooting.
	if Input.is_action_just_released("ui_left_click"):
		is_shooting = false
		state = WANDER


func update_stats(stat):
	if stat == "health":
		var healthbar = get_node("/root/World/UI/Stats/HealthBar")
		var healthtext = get_node("/root/World/UI/Stats/HealthBar/HealthText")
		
		if state != DEAD:
			healthbar.value = player_vars.health
			healthtext.text = str(player_vars.health) + " / " + str(player_vars.max_health)
		else:
			healthbar.value = 0
			healthtext.text = "0 / " + str(player_vars.max_health)
		
		$HealthComponent.update_battlehealth()

	if stat == "energy":
		var energybar = get_node("/root/World/UI/Stats/EnergyBar")
		var energytext = get_node("/root/World/UI/Stats/EnergyBar/EnergyText")
		
		if state != DEAD:
			energybar.value = player_vars.energy
			energytext.text = str(player_vars.energy) + " / " + str(player_vars.max_energy)
		else:
			energybar.value = 0
			energytext.text = "0 / " + str(player_vars.max_energy)
		
		if player_vars.energy > player_vars.max_energy:
			player_vars.energy = player_vars.max_energy


func regenerate(nearest_camp):
	if nearest_camp.flame_state > 0:  # If nearest camp is lit.
		
		# Regenerate energy.
		if player_vars.energy < player_vars.max_energy:
			var add_energy = nearest_camp.flame_state * 2
			if (player_vars.energy + add_energy) > player_vars.max_energy:
				player_vars.energy = player_vars.max_energy
			else:
				player_vars.energy += add_energy
		
		# Regenerate health.
		if player_vars.health < player_vars.max_health:
			var add_health = nearest_camp.flame_state * 2
			if (player_vars.health + add_health) > player_vars.max_health:
				player_vars.health = player_vars.max_health
			else:
				player_vars.health += add_health


func find_nearest_camp():
	var camps = get_tree().get_nodes_in_group("Camps")
	var camp_distances = []
	var nearest
	
	for camp in camps:  # For all nodes in "Camps" group...
		var dist = camp.global_position.distance_squared_to(global_position)

		if dist > 0:  # Get the distance from player, for all camps.
			camp_distances.append(dist)
	
	# Find the nearest one. Smallest distance in list.
	nearest = camps[camp_distances.find(camp_distances.min())]
	
	return nearest
	

func collect_orb(type):
	var orbs = get_node("/root/World/Orbs")
	
	if type == "Health":  # Add to Health.
		player_vars.health += orbs.orb_health
		if player_vars.health > player_vars.max_health:
			player_vars.health = player_vars.max_health
		
	elif type == "Energy":  # Add to Energy.
		player_vars.energy += orbs.orb_energy
		if player_vars.energy > player_vars.max_energy:
			player_vars.energy = player_vars.max_energy


func dead_state():
	player_vars.energy = 0
	player_vars.health = 0
	
	self.hide()
	
	var death_ui = get_node("/root/World/UI/Death/")
	var energytext = get_node("/root/World/UI/Stats/EnergyBar/EnergyText")
	var energybar = get_node("/root/World/UI/Stats/EnergyBar")
	var healthtext = get_node("/root/World/UI/Stats/HealthBar/HealthText")
	var healthbar = get_node("/root/World/UI/Stats/HealthBar")
	
	healthtext.text = "0 / " + str(player_vars.max_health)
	energytext.text = "0 / " + str(player_vars.max_energy)
	
	healthbar.value = 0
	energybar.value = 0
	
	
	if not death_ui.get_node("DeathMenu").is_visible():
		death_ui.deathscreen_show()  # Pauses the tree.
	
	
	# The rest of the code happens when tree is unpaused.

	position = player_vars.spawn_point
	print(position)
	
	state = WANDER
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
	if player_vars.energy >= jump_energy:
		can_jump = true


func _on_idle_regen_timeout():
	if state != DEAD:
		if player_vars.energy < player_vars.max_energy:
				if (player_vars.energy + IDLE_ENERGY_REGEN) > player_vars.max_energy:
					player_vars.energy = player_vars.max_energy
				else:
					player_vars.energy += IDLE_ENERGY_REGEN


func _on_alert_timer_timeout():
	$Alert.hide()


func _on_ladder_checker_area_entered(_area):
	on_ladder = true
	print(on_ladder)


func _on_ladder_checker_area_exited(_area):
	on_ladder = false
	print(on_ladder)


func _on_visible_on_screen_notifier_2d_screen_exited():
	var cam = get_node("/root/World/Player/Camera2D")
	
	if position.y > cam.limit_bottom:
		cam.apply_shake()
		state = DEAD
