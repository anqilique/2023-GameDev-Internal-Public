extends Area2D

@onready var player = get_node("/root/World/Player")
var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(speed * delta)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  # Destroy when off-screen


func _on_body_entered(body):
	if body != player:
		queue_free()  # Destroy on hitting target


func _on_hitbox_area_entered(area):
	var parent = area.get_parent()
	
	# If bullet enters something with a Hitbox, deal damage.
	if area is HitboxComponent and parent != player:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		
		attack.attack_damage = 10

		hitbox.damage(attack)
		queue_free()

