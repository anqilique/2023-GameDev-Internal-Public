extends CharacterBody2D


func _ready():
	$HoverText.hide()
	
	var required_spawn = get_node("/root/World/Ship").required_spawn
	
	if required_spawn != []:
		$Sprite2D.frame = required_spawn[randi() % required_spawn.size()]
		required_spawn.erase($Sprite2D.frame)
	
func _physics_process(_delta):
	var player = get_node("/root/World/Player")
	
	if Input.is_action_just_pressed("ui_interact") and player in $CollectRange.get_overlapping_bodies():
		$HoverText.hide()
		queue_free()
		
		print(">> Player picked up Part")
		
		var type = $Sprite2D.frame
		player.collected_parts[type] += 1
		
		print(">> Player Collected Part Type")
		print(player.collected_parts[type])
		
		print(">> Total Parts Collected")
		print(player.collected_parts)


func _on_collect_range_body_entered(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.show()


func _on_collect_range_body_exited(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.hide()
