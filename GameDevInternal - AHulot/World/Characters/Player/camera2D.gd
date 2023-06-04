extends Camera2D

@onready var player = get_node("/root/World/Player")

func _physics_process(delta):
	if player.motion.x > 15 or player.motion.y > 15 or -player.motion.x > -15 or -player.motion.y > -15:
		global_position = player.global_position.round()
		force_update_scroll()
