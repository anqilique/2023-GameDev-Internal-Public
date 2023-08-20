extends Control


func _ready():
	$TimeText.text = "Day " + global.display_day + " : " + "Hour " +  global.display_hour

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TimeText.text = "Day " + global.display_day + " : " + "Hour " +  global.display_hour
	

func _on_hour_timer_timeout():
	if global.current_scene != "TutorialOne":
		
		if global.hours_left == 1:
			global.current_hour = 0
			global.hours_left = 24
			
			global.current_day += 1
			global.days_left -= 1
			
			# Collision kills player.
			if global.days_left <= 0:
				var player = get_node("/root/World/Player")
				player.dead_state()
				
				$HourTimer.stop()
				
		else:
			global.hours_left -= 1
			global.current_hour += 1
		
		if len(str(global.current_day)) == 1:
			global.display_day = "0" + str(global.current_day)
		else:
			global.display_day = str(global.current_day)
			
		if len(str(global.current_hour)) == 1:
			global.display_hour = "0" + str(global.current_hour)
		else:
			global.display_hour = str(global.current_hour)
	
