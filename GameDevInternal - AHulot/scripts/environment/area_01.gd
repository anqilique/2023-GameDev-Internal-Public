extends Node2D

@export var grounded_scene : PackedScene
@export var flying_scene : PackedScene
@export var item_scene : PackedScene
@export var camp_scene : PackedScene
@export var part_scene : PackedScene

@onready var player = get_node("/root/World/Player")

var type
var new_enemy
var new_item
var new_camp
var new_part

var enemy_spawnpoints = [
]

var item_spawnpoints = [
]

var part_spawnpoints = [
]

var camp_spawnpoints = [
]


# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn enemies
	for spawnpoint in enemy_spawnpoints:
		type = randi_range(1, 2)

		# Randomise type of enemy
		if type == 1:
			new_enemy = grounded_scene.instantiate()
		else:
			new_enemy = flying_scene.instantiate()
		
		new_enemy.position = spawnpoint
		
		add_sibling.call_deferred(new_enemy)
		new_enemy.add_to_group("Enemies")

	# Spawn items
	for spawnpoint in item_spawnpoints:
		new_item = item_scene.instantiate()
		new_item.position = spawnpoint
		add_sibling.call_deferred(new_item)
	
	# Spawn ship parts
	for spawnpoint in part_spawnpoints:
		new_part = part_scene.instantiate()
		new_part.position = spawnpoint
		
		add_sibling.call_deferred(new_part)
		new_part.add_to_group("Parts")

	# Spawn campfires
	for spawnpoint in camp_spawnpoints:
		new_camp = camp_scene.instantiate()
		new_camp.position = spawnpoint
		
		add_sibling.call_deferred(new_camp)
		new_camp.add_to_group("Camps")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global.change_scene()
