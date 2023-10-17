extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	
	var score = global.time_left
	$CanvasLayer/Score.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_pressed():  # Go to main menu.
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
