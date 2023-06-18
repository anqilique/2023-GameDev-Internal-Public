extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int
@export var health : int

@onready var player = get_node("/root/World/Player")
@onready var parent = get_parent()

func _ready():
	var false_blocks = get_tree().get_nodes_in_group("False Blocks")
	
	if parent not in false_blocks:
		var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
		battle_healthbar.max_value = MAX_HEALTH
	
	health = MAX_HEALTH
	

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		if parent != player:
			
			if parent.has_meta("Enemy"):
				var orbs = get_node("/root/World/Orbs")
				orbs.wait_spawn(parent.global_position)
				
			parent.queue_free()
			
		if parent == player:
			var cam = get_node("/root/World/Player/Camera2D")
			cam.apply_shake()
			
			player.is_alive = false
			health = 0
	
	if parent.has_method("hit_state"):
		parent.hit_state()

	var false_blocks = get_tree().get_nodes_in_group("False Blocks")
	if parent not in false_blocks:
		update_battlehealth()


func update_battlehealth():
	health = parent.get_node("HealthComponent").health
	MAX_HEALTH = parent.get_node("HealthComponent").MAX_HEALTH
	
	var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
	battle_healthbar.value = health
	
	if health >= MAX_HEALTH:
		battle_healthbar.hide()
	else:
		battle_healthbar.show()


"""
Player Exclusive Functions Below
"""

func regen_health(nearest_camp):
	var player_healthcomp = get_node("/root/World/Player/HealthComponent")
	
	if nearest_camp.flame_state > 0:
		if player_healthcomp.health < player_healthcomp.MAX_HEALTH:
			var add_health = nearest_camp.flame_state
			
			if (player_healthcomp.health + add_health) > player_healthcomp.MAX_HEALTH:
				player_healthcomp.health = player_healthcomp.MAX_HEALTH
			else:
				player_healthcomp.health += add_health

func health_orb():
	var player_healthcomp = get_node("/root/World/Player/HealthComponent")
	var orb_health = get_node("/root/World/Orbs").orb_health
	
	player_healthcomp.health += orb_health
	
	if player_healthcomp.health > player_healthcomp.MAX_HEALTH:
			player_healthcomp.health = player_healthcomp.MAX_HEALTH

func respawn():
	var player = get_node("/root/World/Player")
	var health = get_node("/root/World/Player/HealthComponent")
	
	health.health = 0.2 * health.MAX_HEALTH
	
	player.position = player.spawn_point
	player.position.y -= 10
