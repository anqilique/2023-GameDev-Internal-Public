extends Node2D

@onready var player = get_node("/root/World/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	global.spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global.change_scene()


func _on_portal_to_green_four_1_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(714, 108)
		global.current_scene = "GreenFour"
		global.transition_scene = true


func _on_portal_to_green_four_2_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(714, 332)
		global.current_scene = "GreenFour"
		global.transition_scene = true
