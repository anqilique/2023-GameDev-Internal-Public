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
	if parent == player:
		health = player_vars.health - attack.attack_damage
		player_vars.health = health
	else:
		health -= attack.attack_damage
	
	if health <= 0:
		if parent != player:
			if parent.has_meta("Enemy"):
				var orbs = get_node("/root/World/Orbs")
				orbs.wait_spawn(parent.global_position)
				
				var enemy_id = parent.enemy_id
				
				if enemy_id in global.scene_spawn[global.current_scene]["enemies"]:
					global.scene_spawn[global.current_scene]["enemies"].erase(enemy_id)
				
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
	
	if parent == player:
		MAX_HEALTH = player_vars.max_health
		health = player_vars.health
	else:
		MAX_HEALTH = parent.get_node("HealthComponent").MAX_HEALTH
	
	var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
	
	battle_healthbar.value = health
	
	if health >= MAX_HEALTH:
		battle_healthbar.hide()
	else:
		battle_healthbar.show()
