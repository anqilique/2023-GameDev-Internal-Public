extends Node2D

@onready var player = get_node("/root/World/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	global.spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global.change_scene()


func _on_portal_to_green_three_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(706, 80)
		global.current_scene = "GreenThree"
		global.transition_scene = true


func _on_portal_to_green_five_1_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(32, 108)
		global.current_scene = "GreenFive"
		global.transition_scene = true


func _on_portal_to_green_five_2_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(32, 332)
		global.current_scene = "GreenFive"
		global.transition_scene = true


func _on_portal_to_green_seven_1_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(60, 117)
		global.current_scene = "GreenSeven"
		global.transition_scene = true


func _on_portal_to_green_seven_2_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(652, 117)
		global.current_scene = "GreenSeven"
		global.transition_scene = true
