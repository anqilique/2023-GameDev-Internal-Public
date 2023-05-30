extends Area2D

var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("Bullet", 1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(speed * delta)
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	var blocks = get_node("/root/World/TileMap")
	
	# Destroy when hitting blocks/walls/floor
	if body == blocks:
		queue_free()
		
	pass
