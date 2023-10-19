extends Control

@export var debugging = false


func _ready():
	if get_tree().current_scene.scene_file_path == "res://scenes/menu/menu.tscn":
		$Player/AnimationPlayer.play("idle")
		$CanvasLayer/PlayOptions.hide()
		$CanvasLayer/TutorialAsk.hide()


func _on_play_pressed():  # Tutorial: Yes / No / Cancel
	audio.play_sound("button_press")
	$CanvasLayer/MainOptions.hide()
	$CanvasLayer/PlayOptions.show()
	$CanvasLayer/TutorialAsk.show()


func _on_controls_pressed():  # Controls
	audio.play_sound("button_press")
	get_tree().change_scene_to_file("res://scenes/menu/controls.tscn")

func _on_credits_pressed():
	audio.play_sound("button_press")
	get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")

func _on_exit_pressed():  # Exit
	audio.play_sound("button_press")
	get_tree().quit()


func _on_back_pressed():  # Main Menu
	audio.play_sound("button_press")
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_yes_pressed():  # Play Tutorial
	audio.play_sound("button_press")
	global.reload()
	
	get_tree().change_scene_to_file("res://scenes/environment/tutorial_01.tscn")


func _on_no_pressed():  # Play Game
	audio.play_sound("button_press")
	global.reload()

	# For quick testing in certain scenes.
	if debugging and Input.is_action_pressed("ui_interact"):
		player_vars.spawn_point = Vector2(32, 108)
		global.current_scene = "GreenFive"

		get_tree().change_scene_to_file("res://scenes/environment/green_05.tscn")
	
	else:  # If not debugging, play normally.
		player_vars.spawn_point = Vector2(668, -12)
		global.current_scene = "GreenTwo"

		get_tree().change_scene_to_file("res://scenes/environment/green_02.tscn")


func _on_cancel_pressed():  # Play / Controls / Exit
	audio.play_sound("button_press")
	$CanvasLayer/MainOptions.show()
	$CanvasLayer/PlayOptions.hide()
	$CanvasLayer/TutorialAsk.hide()


func _on_fullscreen_pressed():
	audio.play_sound("button_press")
	
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_sound_pressed():
	if global.sound_enabled:
		global.sound_enabled = false
		audio.stop_all()
	else:
		global.sound_enabled = true
	
	audio.play_sound("button_press")
