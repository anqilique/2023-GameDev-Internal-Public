extends Node


"""
Scene List
- TutorialOne
- AreaOne
"""

var current_scene = "TutorialOne"
var transition_scene = false

var positions = {
	"TutorialOne" : Vector2(15, 75),
	"AreaOne" : Vector2(668, -12)
}


func end_transition():
	var player = get_node("/root/World/Player")
	player.global_position = positions[current_scene]
	
	if transition_scene:
		transition_scene = false


func change_scene():
	if transition_scene:
		
		match current_scene:
			"TutorialOne" : get_tree().change_scene_to_file("res://scenes/environment/tutorial_01.tscn")
			"AreaOne" : get_tree().change_scene_to_file("res://scenes/environment/area_01.tscn")
			
		end_transition()
