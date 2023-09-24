extends CharacterBody2D

@onready var player = get_node("/root/World/Player")


var parts_progress
var fully_repaired = false


func _ready():
	
	# Max = Total No. of required parts.
	$ProgressBar.max_value = 0
	for type in global.required_parts.keys():
		$ProgressBar.max_value += global.required_parts[type]
	
	# Ship parts = Total parts returned to ship.
	global.total_parts = 0
	for type in global.ship_parts.keys():
		global.total_parts += global.ship_parts[type]
	$ProgressBar.value = global.total_parts
	
	# Floating text = #Collected / #Required for each part type.
	parts_progress = ""
	for type in global.required_parts.keys():
		parts_progress += str(global.ship_parts[type]) + " / " + str(global.required_parts[type]) + "\n"
	
	
	$ProgressBar.hide()
	$Resources.hide()


func _physics_process(_delta):
	$Resources.text = parts_progress
	
	if Input.is_action_just_pressed("ui_interact") and player in $Range.get_overlapping_bodies():
		$Burst.emitting = true
		
		# 'Return' player's parts to ship.
		global.ship_parts = player_vars.collected_parts
		
		# Update progress bar to total parts collected.
		global.total_parts = 0
		for type in global.ship_parts.keys():
			global.total_parts += global.ship_parts[type]
		$ProgressBar.value = global.total_parts
		
		# Update floating text.
		parts_progress = ""
		for type in global.required_parts.keys():
			parts_progress += str(global.ship_parts[type]) + " / " + str(global.required_parts[type]) + "\n"
	
		# If enough parts collected --> Ship repaired.
		if $ProgressBar.value >= $ProgressBar.max_value:
			fully_repaired = true
			print(">> Fully repaired!")
	
	# Ship repaired --> Complete game.
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
