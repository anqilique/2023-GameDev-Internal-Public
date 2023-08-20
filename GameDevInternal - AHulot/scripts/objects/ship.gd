extends CharacterBody2D

@onready var player = get_node("/root/World/Player")


var parts_progress
var fully_repaired = false
var required_spawn = []


func _ready():
	$ProgressBar.max_value = 0
	for type in global.required_parts.keys():
		$ProgressBar.max_value += global.required_parts[type]
	
	global.total_parts = 0
	for type in global.ship_parts.keys():
		global.total_parts += global.ship_parts[type]
		
	$ProgressBar.value = global.total_parts
		
	parts_progress = ""
	for type in global.required_parts.keys():
		parts_progress += str(global.ship_parts[type]) + " / " + str(global.required_parts[type]) + "\n"
	
	for required_type in global.required_parts.keys():
		for r in range(global.required_parts[required_type]):
			global.required_spawn.append(required_type)
	
	$ProgressBar.hide()
	$Resources.hide()
	
	$AnimationPlayer.play("flicker")


func _physics_process(_delta):
	$Resources.text = parts_progress
	
	if Input.is_action_just_pressed("ui_interact") and player in $Range.get_overlapping_bodies():
		global.ship_parts = player_vars.collected_parts
		
		global.total_parts = 0
		for type in global.ship_parts.keys():
			global.total_parts += global.ship_parts[type]
		
		$ProgressBar.value = global.total_parts

		parts_progress = ""
		for type in global.required_parts.keys():
			parts_progress += str(global.ship_parts[type]) + " / " + str(global.required_parts[type]) + "\n"
	
		if $ProgressBar.value >= $ProgressBar.max_value:
			fully_repaired = true
			print(">> Fully repaired!")
	
	if fully_repaired:
		get_tree().paused = true
		get_tree().change_scene_to_file("res://scenes/menu/complete.tscn")


func _on_range_body_entered(body):
	if body == player:
		$Resources.show()
		$ProgressBar.show()


func _on_range_body_exited(body):
	if body == player:
		$Resources.hide()
		$ProgressBar.hide()
