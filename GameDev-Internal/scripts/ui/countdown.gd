extends Control


func _ready():
	$TimeText.text = str(global.time_left)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Always keep the countdown text updated.
	$TimeText.text = str(global.time_left)
	

func _on_timer_timeout():
	if global.current_scene != "TutorialOne":  # No time lost during tutorial.
		
		if global.time_left == 0:  
			$Timer.stop()
			
			# Out of time --> Player death.
			
			var cam = get_node("/root/World/Player/Camera2D")
			cam.apply_shake()
			
			var player = get_node("/root/World/Player")
			player.dead_state()
			
		else:
			global.time_left -= 1
			
