extends Control

@onready var death_ui = get_node("/root/World/UI/Death/")


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = $PauseMenu.PROCESS_MODE_ALWAYS
	$PauseMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Pause shortcut 'P' can work at any time, if player is not dead.
	if Input.is_action_just_pressed("pause") and not death_ui.get_node("DeathMenu").is_visible():
		audio.play_sound("button_press")
		if not get_tree().paused:
			_on_pause_button_pressed()
		else:
			_on_resume_pressed()


func _on_pause_button_pressed():  # Pause.
	# Can't access pause menu if dead. --> Death has its own menu.	
	if not death_ui.get_node("DeathMenu").is_visible():
		audio.play_sound("button_press")
		$PauseMenu.show()
		get_tree().paused = true


func _on_resume_pressed():  # Unpause.
	audio.play_sound("button_press")
	$PauseMenu.hide()
	get_tree().paused = false
	


func _on_quit_pressed():  # Go to main menu.
	audio.play_sound("button_press")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
