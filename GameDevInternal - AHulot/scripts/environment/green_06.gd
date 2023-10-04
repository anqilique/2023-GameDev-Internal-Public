extends Node2D

@onready var player = get_node("/root/World/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	global.spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global.change_scene()


func _on_portal_to_green_seven_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(31, 235)
		global.current_scene = "GreenSeven"
		global.transition_scene = true


func _on_portal_to_green_three_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(251, 391)
		global.current_scene = "GreenThree"
		global.transition_scene = true
