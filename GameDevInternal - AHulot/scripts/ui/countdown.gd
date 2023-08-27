extends Control


func _ready():
#	$TimeText.text = "Day " + global.display_day + " : " + "Hour " +  global.display_hour
	$TimeText.text = str(global.time_left)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	$TimeText.text = "Day " + global.display_day + " : " + "Hour " +  global.display_hour
	$TimeText.text = str(global.time_left)
	

func _on_timer_timeout():
	if global.current_scene != "TutorialOne":
		
		if global.time_left == 0:
			$Timer.stop()
			
			var cam = get_node("/root/World/Player/Camera2D")
			cam.apply_shake()
			
			var player = get_node("/root/World/Player")
			player.dead_state()
			
		else:
			global.time_left -= 1
			
