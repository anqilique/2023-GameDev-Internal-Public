extends Node2D

@onready var player = get_node("/root/World/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Camp.hide()
	$AbtEnemies.hide()
	$AbtOrbs.hide()
	$UI/Countdown.hide()

	global.spawn()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global.change_scene()
	
	if Input.is_action_just_released("ui_interact"):
		if not $Camp.is_visible() and player in $CampTextTrig.get_overlapping_bodies():
			$Camp.show()


func _on_portal_to_world_body_entered(body):
	if body == player:
		player_vars.spawn_point = Vector2(668, -12)
		global.current_scene = "GreenTwo"
		global.transition_scene = true
	

func _on_enemies_body_entered(body):
	if body == player and not $AbtEnemies.is_visible():
		$AbtEnemies.show()


func _on_orbs_text_trig_body_entered(body):
	if body == player and not $AbtOrbs.is_visible():
		$AbtOrbs.show()


func _on_camp_text_trig_area_entered(area):
	player_vars.spawn_point = player.global_position
