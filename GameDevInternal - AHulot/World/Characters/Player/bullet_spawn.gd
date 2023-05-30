extends Node2D

@export var bullet_scene: PackedScene

var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("ui_left_click") and can_shoot:
		can_shoot = false
		
		_shoot()
		$CanShoot.start()
		

func _shoot():
	var bullet = bullet_scene.instantiate()
	
	bullet.rotation = rotation
	
	add_sibling(bullet)


func _on_can_shoot_timeout():
	can_shoot = true
