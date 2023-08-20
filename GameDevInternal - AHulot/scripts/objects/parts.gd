extends CharacterBody2D


var part_id


func _ready():
	$HoverText.hide()
	
	print(global.required_spawn)
	
	if global.required_spawn != []:
		$Sprite2D.frame = global.required_spawn[randi() % global.required_spawn.size()]
	
	part_id = global_position
	
func _physics_process(_delta):
	var player = get_node("/root/World/Player")
	
	if Input.is_action_just_pressed("ui_interact") and player in $CollectRange.get_overlapping_bodies():
		$HoverText.hide()
		queue_free()
		
		print(">> Player picked up Part")
		
		var type = $Sprite2D.frame
		player_vars.collected_parts[type] += 1
		global.required_spawn.erase($Sprite2D.frame)
		
		if part_id in global.scene_spawn[global.current_scene]["parts"]:
			global.scene_spawn[global.current_scene]["parts"].erase(part_id)
		
		print(">> Player Collected Part Type")
		print(player_vars.collected_parts[type])
		
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
