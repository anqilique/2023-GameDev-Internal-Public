extends Node2D

@export var grounded_scene : PackedScene
@export var flying_scene : PackedScene
@export var item_scene : PackedScene
@export var camp_scene : PackedScene
@export var part_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var type
	var new_enemy
	var new_item
	var new_camp
	var new_part
	
	var enemy_spawnpoints = [
		Vector2(339, 110), 
		Vector2(355, 108),
		Vector2(383, 51),
		Vector2(323, 42),
		Vector2(240, 10),
		Vector2(78, -16),
		Vector2(45, 363),
		Vector2(214, 75),
		Vector2(188, 35)
	]

	var item_spawnpoints = [
		Vector2(915, 725),
	]
	
	var part_spawnpoints = [
		Vector2(603, 82),
		Vector2(108, 223),
		Vector2(372, 404),
		Vector2(587, 244),
		Vector2(903, 516),
		Vector2(366, 806)
	]
	
	var camp_spawnpoints = [
		Vector2(388, 121),
		Vector2(68, 72)
	]
	
	RenderingServer.set_default_clear_color(Color.html("493d3c"))
	
	# Spawn enemies
	for spawnpoint in enemy_spawnpoints:
		type = randi_range(1, 2)

		# Randomise type of enemy
		if type == 1:
			new_enemy = grounded_scene.instantiate()
		else:
			new_enemy = flying_scene.instantiate()
		
		new_enemy.position = spawnpoint
		
		add_sibling(new_enemy)
		new_enemy.add_to_group("Enemies")

	# Spawn items
	for spawnpoint in item_spawnpoints:
		new_item = item_scene.instantiate()
		new_item.position = spawnpoint
		add_sibling(new_item)
	
	# Spawn ship parts
	for spawnpoint in part_spawnpoints:
		new_part = part_scene.instantiate()
		new_part.position = spawnpoint
		
		add_sibling(new_part)
		new_part.add_to_group("Parts")

	# Spawn campfires
	for spawnpoint in camp_spawnpoints:
		new_camp = camp_scene.instantiate()
		new_camp.position = spawnpoint
		
		add_sibling(new_camp)
		new_camp.add_to_group("Camps")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
