extends Control


func _ready():
	if get_tree().current_scene.scene_file_path == "res://scenes/menu/menu.tscn":
		$Player/AnimationPlayer.play("idle")
		$CanvasLayer/MarginContainer2.hide()
		$CanvasLayer/TutorialAsk.hide()


func _on_play_pressed():  # Play game
	$CanvasLayer/MarginContainer.hide()
	$CanvasLayer/MarginContainer2.show()
	$CanvasLayer/TutorialAsk.show()


func _on_controls_pressed():  # Controls
	get_tree().change_scene_to_file("res://scenes/menu/controls.tscn")


func _on_exit_pressed():  # Exit
	get_tree().quit()


func _on_back_pressed():  # Main Menu
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_yes_pressed():  # Tutorial
	global.load()
	
	get_tree().change_scene_to_file("res://scenes/environment/tutorial_01.tscn")


func _on_no_pressed():  # Game
	global.load()
	
	player_vars.spawn_point = Vector2(668, -12)
	global.current_scene = "GreenTwo"
	
	get_tree().change_scene_to_file("res://scenes/environment/green_02.tscn")


func _on_cancel_pressed():
	$CanvasLayer/MarginContainer.show()
	$CanvasLayer/MarginContainer2.hide()
	$CanvasLayer/TutorialAsk.hide()
