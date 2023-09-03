extends CharacterBody2D


var part_id


func _ready():
	$HoverText.hide()
	
	global.required_spawn = []
	for required_type in global.required_parts.keys():
		if player_vars.collected_parts[required_type] < global.required_parts[required_type]:
			for r in range(global.required_parts[required_type] - player_vars.collected_parts[required_type]):
				global.required_spawn.append(required_type)
	
	print(global.required_spawn)
	
	if global.required_spawn != []:
		$Sprite2D.frame = global.required_spawn[randi() % global.required_spawn.size()]
	
	part_id = global_position
	
func _physics_process(_delta):
	if get_tree().current_scene.scene_file_path not in global.pause_scenes:
		var player = get_node("/root/World/Player")
		var type = $Sprite2D.frame
		
		if global.required_spawn != []:
			if type not in global.required_spawn:
				$Sprite2D.frame = global.required_spawn[randi() % global.required_spawn.size()]
		
		if Input.is_action_just_pressed("ui_interact") and player in $CollectRange.get_overlapping_bodies():
			$HoverText.hide()
			queue_free()
			
			print(">> Player picked up Part")
			
			player_vars.collected_parts[type] += 1
			global.required_spawn.erase(type)
			
			if part_id in global.scene_spawn[global.current_scene]["parts"]:
				global.scene_spawn[global.current_scene]["parts"].erase(part_id)
			
			print(">> Player Collected Part Type")
			print(type)
			
			print(">> Total Parts Collected")
			print(player_vars.collected_parts)


func _on_collect_range_body_entered(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.show()


func _on_collect_range_body_exited(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.hide()
