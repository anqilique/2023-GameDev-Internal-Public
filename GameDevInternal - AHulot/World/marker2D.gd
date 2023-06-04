extends Marker2D

@onready var player = get_node("/root/World/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = player.global_position
	var target_pos_x
	var target_pos_y
	
	target_pos_x = int(lerp(global_position.x, target.x, 0.2))
	target_pos_y = int(lerp(global_position.y, target.y, 0.2))
	
	global_position = Vector2(target_pos_x, target_pos_y)
