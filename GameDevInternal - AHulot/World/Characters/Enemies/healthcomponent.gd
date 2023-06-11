extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int
@export var health : int

@onready var player = get_node("/root/World/Player")
@onready var parent = get_parent()

func _ready():
	var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
	
	health = MAX_HEALTH
	battle_healthbar.max_value = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		if parent != player:
			parent.queue_free()
		if parent == player:
			player.is_alive = false
			
			if player.is_alive == false:
				health = 0
	
	if parent.has_method("hit_state"):
		parent.hit_state()

	update_battlehealth()

func update_battlehealth():
	health = parent.get_node("HealthComponent").health
	MAX_HEALTH = parent.get_node("HealthComponent").MAX_HEALTH
	var battle_healthbar = parent.get_node("Sprite2D/BattleHealthBar")
	
	if health >= MAX_HEALTH:
		battle_healthbar.hide()
	else:
		battle_healthbar.show()
	
	battle_healthbar.value = health
	
	if health >= MAX_HEALTH:
		battle_healthbar.hide()
	else:
		battle_healthbar.show()


"""
Player Exclusive Functions Below
"""

func regen_health():
	var player = get_node("/root/World/Player/HealthComponent")
	var flame_state = get_node("/root/World/Camp").flame_state
	
	if player.health < player.MAX_HEALTH:
		var add_health = flame_state
		
		if (player.health + add_health) > player.MAX_HEALTH:
			player.health = player.MAX_HEALTH
		else:
			player.health += add_health

func respawn():
	var player = get_node("/root/World/Player")
	var health = get_node("/root/World/Player/HealthComponent")
	
	health.health = 0.2 * health.MAX_HEALTH
	
	player.position = get_node("/root/World/Camp").position
	player.position.y -= 10
