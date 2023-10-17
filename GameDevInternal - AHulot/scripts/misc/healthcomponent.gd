extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int
@export var health : int

@onready var player = get_node("/root/World/Player")
@onready var parent = get_parent()


func _ready():
	var false_blocks = get_tree().get_nodes_in_group("False Blocks")
	
	if parent not in false_blocks:  # False blocks do not display a health bar.
		var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
		battle_healthbar.max_value = MAX_HEALTH
	
	# Set the health of the obj. to its max health.
	health = MAX_HEALTH
	

func damage(attack: Attack):
	if parent == player:  # Modify player's global variables when attacked.
		health = player_vars.health - attack.attack_damage
		player_vars.health = health
		
	else:  # If not the player, just decrease health.
		health -= attack.attack_damage
	
	if health <= 0:  # If dead...
		if parent != player:  # And health component is not the player's...
			if parent.has_meta("Enemy"):
				
				# Spawn orbs for player to collect.
				var orbs = get_node("/root/World/Orbs")
				orbs.wait_spawn(parent.global_position)
				
				var enemy_id = parent.enemy_id
				
				# Prevent the dead enemy from being respawned later on.
				if enemy_id in global.scene_spawn[global.current_scene]["enemies"]:
					global.scene_spawn[global.current_scene]["enemies"].erase(enemy_id)
			
			# Delete enemy.
			audio.play_sound("enemy_death")
			parent.queue_free()
			
		if parent == player:
			var cam = get_node("/root/World/Player/Camera2D")
			cam.apply_shake()
			
			audio.play_sound("player_death")
			
			player.is_alive = false
			health = 0
	
	if parent.has_method("hit_state"):
		parent.hit_state()
		
	var false_blocks = get_tree().get_nodes_in_group("False Blocks")
	
	if parent not in false_blocks:  # If not a false block...
		update_battlehealth()  # Update floating health bar.


func update_battlehealth():
	health = parent.get_node("HealthComponent").health
	
	if parent == player:  # Use the player's global variables.
		MAX_HEALTH = player_vars.max_health
		health = player_vars.health
	else:  # Otherwise use the parent's health component variables.
		MAX_HEALTH = parent.get_node("HealthComponent").MAX_HEALTH
	
	var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
	
	battle_healthbar.value = health
	
	# If they have taken damage, show health bar.
	if health >= MAX_HEALTH:
		battle_healthbar.hide()
	else:
		battle_healthbar.show()
