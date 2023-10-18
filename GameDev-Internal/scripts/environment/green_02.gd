extends Node2D


@onready var player = get_node("/root/World/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	global.spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global.change_scene()


func _on_portal_to_green_one_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(712, 380)
		global.current_scene = "GreenOne"
		global.transition_scene = true


func _on_portal_to_green_three_1_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(20, 255)
		global.current_scene = "GreenThree"
		global.transition_scene = true


func _on_portal_to_green_three_2_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(20, 375)
		global.current_scene = "GreenThree"
		global.transition_scene = true
