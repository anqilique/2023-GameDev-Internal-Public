extends Node2D

var light_cost
var can_regen
var flame_state

# Called when the node enters the scene tree for the first time.
func _ready():
	$Flame.hide()
	$HoverText.hide()
	flame_state = 0
	light_cost = 0
	can_regen = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("/root/World/Player")
	var player_health = get_node("/root/World/Player/HealthComponent")
	light_cost = flame_state * 2
	
	# Play correct animation if flame is lit.
	if flame_state > 0:
		$Flame.show()
		$Flame/PointLight2D.scale.x = flame_state * 0.03
		$Flame/PointLight2D.scale.y = flame_state * 0.03
		$Flame/AnimationPlayer.play(str(flame_state - 1))
	else:
		$Flame.hide()
		can_regen = false
	
	# When [E] pressed, light/stoke the fire.
	if Input.is_action_just_pressed("ui_interact") and player in $Range.get_overlapping_bodies():
		$HoverText.hide()
		
		if player.energy > light_cost:
			if flame_state < 8:
				player.energy -= light_cost
				
				if $Flame.is_visible():
					flame_state += 1
					$Regen.start()
					$Shrink.start()
				else:
					flame_state = 1
					$Regen.start()
					$Shrink.start()
	
	# Allow player to regenerate energy/health if close to fire.
	if $Flame.is_visible() and player in $Range.get_overlapping_bodies():
		if can_regen:
			var nearest = player.find_nearest_camp()
			
			player.regenerate(nearest)
			player_health.regen_health(nearest)
			
			can_regen = false
			$Regen.start()

func _on_shrink_timeout():
	# Fire grows smaller as time passes.
	if flame_state >= 1:
		flame_state -= 1

func _on_regen_timeout():
	can_regen = true
	

func _on_range_body_entered(body):
	var player = get_node("/root/World/Player")
	
	# Set the player's spawn point to the fire's location.
	if body == player:
		player.spawn_point = player.global_position
		
		if flame_state < 1:
			$HoverText.show()

func _on_range_body_exited(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.hide()
