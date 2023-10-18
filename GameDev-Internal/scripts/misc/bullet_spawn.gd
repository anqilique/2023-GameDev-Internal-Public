extends Node2D

@export var bullet_scene : PackedScene

var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	look_at(get_global_mouse_position())
	
	var player = get_node("/root/World/Player")
	
	# If the player is not dead and has enough energy: Shoot.
	if player.is_alive:
		if player_vars.energy >= player.shoot_energy:
			if Input.is_action_pressed("ui_left_click") and can_shoot:
				audio.play_sound("player_shoot")
				can_shoot = false
				_shoot()
				$CanShoot.start()
		

func _shoot():
	var bullet = bullet_scene.instantiate()
	var spawn = get_node("/root/World/Player/BulletSpawn")
	var player = get_node("/root/World/Player")
	
	# Spawn bullet from the player.
	bullet.position = spawn.position
	bullet.rotation = rotation
	
	add_sibling(bullet)
	
	# Shooting ueses energy.
	player_vars.energy -= player.shoot_energy


func _on_can_shoot_timeout():
	can_shoot = true
