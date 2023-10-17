extends Node2D

var light_cost
var can_regen
var flame_state


# Called when the node enters the scene tree for the first time.
func _ready():
	$Flame.hide()
	$Particles.hide()
	$HoverText.hide()
	
	flame_state = 0
	light_cost = 0
	can_regen = false
	
	set_meta("Camp", 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().current_scene.scene_file_path not in global.pause_scenes:
		var player = get_node("/root/World/Player")
		light_cost = flame_state * 2
		
		# Play correct animation if flame is lit.
		if flame_state > 0:
			
			$Flame.show()
			
			# Increase size of light based on the size of the fire.
			$Flame/PointLight2D.scale.x = flame_state * 0.03
			$Flame/PointLight2D.scale.y = flame_state * 0.03
			
			if not $Flame/AnimationPlayer.is_playing():
				$Flame/AnimationPlayer.play(str(flame_state - 1))
			
			$Particles.show()
			
			
		else:
			$Flame.hide()
			$Particles.hide()
			can_regen = false
		
		# When [E] pressed, light/stoke the fire.
		if Input.is_action_just_pressed("ui_interact") and player in $Range.get_overlapping_bodies():
			$HoverText.hide()
			audio.play_sound("camp_int")
			
			# Player loses energy.
			if player_vars.energy > light_cost:
				if flame_state < 8:
					player_vars.energy -= light_cost
					
					if $Flame.is_visible():  # Fire grows larger.
						flame_state += 1
						$Regen.start()
						$Shrink.start()
						
					else:
						flame_state = 1  # Fire is lit.
						$Regen.start()
						$Shrink.start()
			
			# Particle animation.
			$Particles.hide()
			$Burst.amount = flame_state + 1
			$Burst.emitting = true
			$Particles.amount = flame_state + 1
			$Particles.show()
			
			if flame_state >= 1:
				$Flame/AnimationPlayer.play(str(flame_state - 1))
			
		
		# Allow player to regenerate energy/health if close to fire.
		if $Flame.is_visible() and player in $Range.get_overlapping_bodies():
			if can_regen:
				var nearest = player.find_nearest_camp()
				
				# Regenerate using the nearest lit camp.
				# (In case a scene has two campfires.)
				player.regenerate(nearest)
				can_regen = false
				$Regen.start()


func _on_shrink_timeout():
	# Fire grows smaller as time passes.
	if flame_state >= 1:
		flame_state -= 1
		
		$Particles.hide()
		$Burst.amount = flame_state + 1
		$Burst.emitting = true
		$Particles.amount = flame_state + 1
		$Particles.show()
	
	if (flame_state - 1) >= 0:
		$Flame/AnimationPlayer.play(str(flame_state - 1))


func _on_regen_timeout():
	can_regen = true


func _on_range_body_entered(body):
	var player = get_node("/root/World/Player")
	
	# Set the player's spawn point to the fire's location.
	if body == player:
		player_vars.spawn_point = player.global_position
		
		if flame_state < 1:
			$HoverText.show()


func _on_range_body_exited(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.hide()


func _on_safe_zone_body_entered(body):
	if body.has_meta("Enemy"):
		print(">> !")
