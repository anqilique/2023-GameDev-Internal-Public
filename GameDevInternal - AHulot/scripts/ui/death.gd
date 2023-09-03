extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = $DeathMenu.PROCESS_MODE_ALWAYS
	$DeathMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_interact"):
		if $DeathMenu.is_visible():
			_on_respawn_pressed()


func deathscreen_show():
	$DeathMenu.show()
	get_tree().paused = true


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_respawn_pressed():
	if global.time_left > 0:
		player_vars.energy = 0.1 * player_vars.max_energy
		player_vars.health = 0.25 * player_vars.max_health
		
		get_tree().paused = false
		$DeathMenu.hide()
