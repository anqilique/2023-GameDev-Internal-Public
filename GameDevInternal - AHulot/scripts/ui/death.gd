extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = $DeathMenu.PROCESS_MODE_ALWAYS
	$DeathMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# If dead and 'E' pressed, respawn.
	if Input.is_action_pressed("ui_interact"):
		if $DeathMenu.is_visible():  
			_on_respawn_pressed()


func deathscreen_show():  # Show options after death.
	var notime_msg = false
	
	if global.time_left < 1:
		$DeathMenu/Respawn.text = "RESTART"
		notime_msg = true
	else:
		$DeathMenu/Respawn.text = "RESPAWN"
	
	
	$DeathMenu.show()
	
	if notime_msg:
		$DeathMenu/Label/Label.show()
	else:
		$DeathMenu/Label/Label.hide()
	
	get_tree().paused = true


func _on_quit_pressed():  # Go to main menu.
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_respawn_pressed():
	
	if global.time_left > 0:  # Let the player respawn.
		player_vars.energy = 0.1 * player_vars.max_energy
		player_vars.health = 0.25 * player_vars.max_health
	
	else:  # Restart with the player's progress reset.
		global.reload()  # Player ran out of time --> Start new game.
	
		player_vars.spawn_point = Vector2(668, -12)
		global.current_scene = "GreenTwo"
		
		get_tree().change_scene_to_file("res://scenes/environment/green_02.tscn")
		
	get_tree().paused = false
	$DeathMenu.hide()
