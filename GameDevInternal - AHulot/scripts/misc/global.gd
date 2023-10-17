extends Node


"""
Scene List
- TutorialOne
- GreenOne
- GreenTwo
- GreenThree
- GreenFour
- GreenFive
- GreenSix
- GreenSeven
"""


@export var grounded_scene = preload("res://scenes/characters/grounded-enemy.tscn")
@export var flying_scene = preload("res://scenes/characters/flying-enemy.tscn")
@export var item_scene = preload("res://scenes/objects/item.tscn")
@export var camp_scene = preload("res://scenes/objects/camp.tscn")
@export var part_scene = preload("res://scenes/objects/parts.tscn")

var current_scene = ""
var transition_scene = false
var sound_enabled = true
var total_parts = 0
var time_left = 0
var ship_parts = {}
var required_parts = {}
var scene_spawn = {}
var required_spawn = []

var pause_scenes = [
	"res://scenes/menu/menu.tscn",
	"res://scenes/menu/controls.tscn",
]

func reload():  # Restart/reset scene and player vars.
	
	# 41-51, delete all existing nodes in game world.
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	
	for part in get_tree().get_nodes_in_group("Parts"):
		part.queue_free()
	
	for camp in get_tree().get_nodes_in_group("Camps"):
		camp.queue_free()
	
	for item in get_tree().get_nodes_in_group("Items"):
		item.queue_free()
	
	# 55-64, reset player variables.
	
	player_vars.collected_parts = {
		0 : 0,
		1 : 0,
		2 : 0,
	}

	player_vars.health = 100
	player_vars.energy = 100

	player_vars.spawn_point = Vector2(15, 75)
	
	# 68-85, reset global variables.
	
	current_scene = "TutorialOne"
	transition_scene = false
	total_parts = 0
	time_left = 1000

	ship_parts = {
		0 : 0,
		1 : 0,
		2 : 0
	}

	required_parts = {
		0 : 5,
		1 : 5,
		2 : 5
	}

	required_spawn = [
		0, 0, 0, 0, 0,
		1, 1, 1, 1, 1,
		2, 2, 2, 2, 2,
	]
	
	# 89-198, reset collection of things to spawn in each scene.

	scene_spawn = {

		"TutorialOne" : {
			"enemies" : [
				Vector2(278, 234), 
				Vector2(214, 234),
				Vector2(54, 333),
				Vector2(122, 340),
				Vector2(192, 319)
				],
			"parts" : [],
			"camps" : [
				Vector2(580, 217)
			],
			"items" : []
		},
		
		"GreenOne" : {
			"enemies" : [
				Vector2(447, 378),
				Vector2(442, 271),
				Vector2(628, 305),
				Vector2(94, 160),
				Vector2(556, 50),
				Vector2(556, 50)
				],
			"parts" : [
				Vector2(648, 281),
				Vector2(684, 95)
			],
			"camps" : [],
			"items" : []
		},
		
		"GreenTwo" : {
			"enemies" : [
				Vector2(485, 8),
				Vector2(281, 199)
			],
			"parts" : [
				Vector2(55, 250),
				Vector2(592, 222)
			],
			"camps" : [
				Vector2(479, 240)
			],
			"items" : []
		},
		
		"GreenThree" : {
			"enemies" : [
				Vector2(201, 374),
				Vector2(213, 246),
				Vector2(447, 342),
				Vector2(652, 207),
				Vector2(188, 138),
				Vector2(314, 41),
				Vector2(426, 67)
			],
			"parts" : [
				Vector2(690, 186),
				Vector2(467, 376)
			],
			"camps" : [],
			"items" : []
		},
		
		"GreenFour" : {
			"enemies" : [
				Vector2(248, 71),
				Vector2(320, 71),
				Vector2(411, 71),
				Vector2(470, 71),
				Vector2(564, 71),
				Vector2(576, 175),
				Vector2(490, 175),
				Vector2(391, 175),
				Vector2(297, 175),
				Vector2(53, 213),
				Vector2(94, 284),
				Vector2(363, 301),
				Vector2(484, 314)
			],
			"parts" : [
				Vector2(611, 324),
				Vector2(54, 215)
			],
			"camps" : [],
			"items" : []
		},
		
		"GreenFive" : {
			"enemies" : [
				Vector2(183, 54),
				Vector2(306, 54),
				Vector2(428, 106),
				Vector2(486, 106),
				Vector2(561, 106),
				Vector2(653, 106),
				Vector2(567, 57),
				Vector2(172, 337),
				Vector2(467, 208),
				Vector2(688, 286),
				Vector2(499, 378),
				Vector2(422, 378)
			],
			"parts" : [
				Vector2(352, 362),
				Vector2(246, 168),
				Vector2(572, 102)
			],
			"camps" : [
				Vector2(241, 360)
			],
			"items" : []
		},
		
		"GreenSix" : {
			"enemies" : [
				Vector2(400, 190)
			],
			"parts" : [
				Vector2(340, 160),
				Vector2(510, 166)
			],
			"camps" : [
				Vector2(408, 257)
			],
			"items" : []
		},
		
		"GreenSeven" : {
			"enemies" : [
				Vector2(544, 151),
				Vector2(232, 166),
				Vector2(366, 230),
				Vector2(430, 230)
			],
			"parts" : [
				Vector2(364, 160),
				Vector2(692, 210)
			],
			"camps" : [],
			"items" : []
		},
	}


func change_scene():  # Clear current scene, transition to next one.
	if transition_scene:
		
		# 207-217, delete everything in current scene before transitioning.
		
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			enemy.queue_free()
		
		for part in get_tree().get_nodes_in_group("Parts"):
			part.queue_free()
		
		for camp in get_tree().get_nodes_in_group("Camps"):
			camp.queue_free()
		
		for item in get_tree().get_nodes_in_group("Items"):
			item.queue_free()
		
		
		match current_scene:  # Change to next scene.
			"TutorialOne" : get_tree().change_scene_to_file("res://scenes/environment/tutorial_01.tscn")
			"GreenOne" : get_tree().change_scene_to_file("res://scenes/environment/green_01.tscn")
			"GreenTwo" : get_tree().change_scene_to_file("res://scenes/environment/green_02.tscn")
			"GreenThree" : get_tree().change_scene_to_file("res://scenes/environment/green_03.tscn")
			"GreenFour" : get_tree().change_scene_to_file("res://scenes/environment/green_04.tscn")
			"GreenFive" : get_tree().change_scene_to_file("res://scenes/environment/green_05.tscn")
			"GreenSix" : get_tree().change_scene_to_file("res://scenes/environment/green_06.tscn")
			"GreenSeven" : get_tree().change_scene_to_file("res://scenes/environment/green_07.tscn")
		
		end_transition()


func spawn():  # Spawn everything in current scene.
	
	var type
	var new_enemy
	var new_item
	var new_camp
	var new_part
	
	
	# Spawn enemies
	for spawnpoint in scene_spawn[current_scene]["enemies"]:
		type = randi_range(1, 2)

		# Randomise type of enemy
		if type == 1:
			new_enemy = grounded_scene.instantiate()
		else:
			new_enemy = flying_scene.instantiate()
		
		new_enemy.position = spawnpoint
		new_enemy.z_index += 1
		
		add_sibling.call_deferred(new_enemy)
		new_enemy.add_to_group("Enemies")
	
	# Spawn ship parts
	for spawnpoint in scene_spawn[current_scene]["parts"]:
		new_part = part_scene.instantiate()
		
		new_part.position = spawnpoint
		new_part.z_index += 1
		
		add_sibling.call_deferred(new_part)
		new_part.add_to_group("Parts")
	
	# Spawn campfires
	for spawnpoint in scene_spawn[current_scene]["camps"]:
		new_camp = camp_scene.instantiate()
		
		new_camp.position = spawnpoint
		new_camp.z_index += 1
		
		add_sibling.call_deferred(new_camp)
		new_camp.add_to_group("Camps")
	
	# Spawn items
	for spawnpoint in scene_spawn[current_scene]["items"]:
		new_item = item_scene.instantiate()
		
		new_item.position = spawnpoint
		new_item.z_index += 1
		
		add_sibling.call_deferred(new_item)
		new_item.add_to_group("Items")


func end_transition(): # Move player to new spawnpoint.
	
	var player = get_node("/root/World/Player")
	player.global_position = player_vars.spawn_point
	
	if transition_scene:
		transition_scene = false
