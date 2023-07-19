extends Control


func _on_play_pressed():  # Play game
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_controls_pressed():  # Controls
	get_tree().change_scene_to_file("res://UI/controls.tscn")


func _on_exit_pressed():  # Exit
	get_tree().quit()


func _on_back_pressed():  # Main Menu
	get_tree().change_scene_to_file("res://UI/menu.tscn")


func _on_pressed():  # Main Menu
	get_tree().change_scene_to_file("res://UI/menu.tscn")
