extends Control

@export var debugging = true


func _ready():
	if get_tree().current_scene.scene_file_path == "res://scenes/menu/menu.tscn":
		$Player/AnimationPlayer.play("idle")
		$CanvasLayer/PlayOptions.hide()
		$CanvasLayer/TutorialAsk.hide()


func _on_play_pressed():  # Tutorial: Yes / No / Cancel
	$CanvasLayer/MainOptions.hide()
	$CanvasLayer/PlayOptions.show()
	$CanvasLayer/TutorialAsk.show()


func _on_controls_pressed():  # Controls
	get_tree().change_scene_to_file("res://scenes/menu/controls.tscn")


func _on_exit_pressed():  # Exit
	get_tree().quit()


func _on_back_pressed():  # Main Menu
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_yes_pressed():  # Play Tutorial
	global.load()
	
	get_tree().change_scene_to_file("res://scenes/environment/tutorial_01.tscn")


func _on_no_pressed():  # Play Game
	global.load()

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
	$CanvasLayer/MainOptions.show()
	$CanvasLayer/PlayOptions.hide()
	$CanvasLayer/TutorialAsk.hide()
