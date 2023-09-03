extends Control

@onready var death_ui = get_node("/root/World/UI/Death/")

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = $PauseMenu.PROCESS_MODE_ALWAYS
	$PauseMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and not death_ui.get_node("DeathMenu").is_visible():
		if not get_tree().paused:
			_on_pause_button_pressed()
		else:
			_on_resume_pressed()


func _on_pause_button_pressed():
	if not death_ui.get_node("DeathMenu").is_visible():
		$PauseMenu.show()
		get_tree().paused = true


func _on_resume_pressed():
	get_tree().paused = false
	$PauseMenu.hide()
	

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
