extends Control

var current_hour
var hours_left
var current_day
var days_left
var display_hour
var display_day

# Called when the node enters the scene tree for the first time.
func _ready():
	current_hour = 0
	hours_left = 24
	current_day = 1
	days_left = 10
	display_hour = "00"
	display_day = "01"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TimeText.text = "Day " + display_day + " : " + "Hour " +  display_hour
	

func _on_hour_timer_timeout():
	if hours_left == 1:
		current_hour = 0
		hours_left = 24
		
		current_day += 1
		days_left -= 1
		
		# Collision kills player.
		if days_left <= 0:
			var player = get_node("/root/World/Player")
			player.dead_state()
			
			$HourTimer.stop()
			
	else:
		hours_left -= 1
		current_hour += 1
	
	if len(str(current_day)) == 1:
		display_day = "0" + str(current_day)
	else:
		display_day = str(current_day)
		
	if len(str(current_hour)) == 1:
		display_hour = "0" + str(current_hour)
	else:
		display_hour = str(current_hour)
	
	
	
