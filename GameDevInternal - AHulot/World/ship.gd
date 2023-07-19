extends CharacterBody2D

@onready var player = get_node("/root/World/Player")

var required_parts = {
	0 : 2,
	1 : 2,
	2 : 2
}

var parts_progress
var fully_repaired = false
var required_spawn = []


func _ready():
	$ProgressBar.max_value = 0
	for type in required_parts.keys():
		$ProgressBar.max_value += required_parts[type]
		
	parts_progress = ""
	for type in required_parts.keys():
		parts_progress += "0" + " / " + str(required_parts[type]) + "\n"
	
	for required_type in required_parts.keys():
		for r in range(required_parts[required_type]):
			required_spawn.append(required_type)
	
	$ProgressBar.hide()
	$Resources.hide()


func _physics_process(delta):
	$Resources.text = parts_progress
	
	if Input.is_action_just_pressed("ui_interact") and player in $Range.get_overlapping_bodies():
		var total_parts = 0
		
		for type in player.collected_parts.keys():
			total_parts += player.collected_parts[type]
		
		$ProgressBar.value = total_parts
		
		parts_progress = ""
		for type in required_parts.keys():
			parts_progress += str(player.collected_parts[type]) + " / " + str(required_parts[type]) + "\n"

	if $ProgressBar.value >= $ProgressBar.max_value:
		fully_repaired = true
		print(">> Fully repaired!")
	
	if fully_repaired:
		get_tree().paused = true
		get_tree().change_scene_to_file("res://UI/complete.tscn")


func _on_range_body_entered(body):
	if body == player:
		$Resources.show()
		$ProgressBar.show()


func _on_range_body_exited(body):
	if body == player:
		$Resources.hide()
		$ProgressBar.hide()
