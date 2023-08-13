extends CharacterBody2D


func _ready():
	$HoverText.hide()

func _physics_process(_delta):
	var player = get_node("/root/World/Player")
	
	if Input.is_action_just_pressed("ui_interact") and player in $CollectRange.get_overlapping_bodies():
		$HoverText.hide()
		queue_free()
		
		if player.jump_max < 2:
			player.jump_max = 2
			print(">> Player has unlocked Double Jump")
			player.get_node("Alert").show()
		
		print(">> Player picked up Item")


func _on_collect_range_body_entered(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.show()


func _on_collect_range_body_exited(body):
	var player = get_node("/root/World/Player")
	
	if body == player:
		$HoverText.hide()
