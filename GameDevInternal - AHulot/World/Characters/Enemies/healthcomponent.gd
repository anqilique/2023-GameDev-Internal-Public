extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int
@onready var player = get_node("/root/World/Player")

var health

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	var parent = get_parent()
	
	health -= attack.attack_damage
	
	if health <= 0:
		if parent != player:
			parent.queue_free()
	
	if parent.has_method("hit_state"):
		parent.hit_state()
