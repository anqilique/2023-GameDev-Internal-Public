extends Node


var collected_parts = {
	0 : 0,
	1 : 0,
	2 : 0
}

var health
var energy

var max_energy : int = 100
var max_health : int = 100

var spawn_point = Vector2(15, 75)

func _ready():
	energy = max_energy
	health = max_health
