extends Area2D

@onready var player = get_node("/root/World/Player")
var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(speed * delta)
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body != player:
		queue_free()


func _on_hitbox_area_entered(area):
	# Call damage function if it exists
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		var attack = Attack.new()
		
		attack.attack_damage = 2

		hitbox.damage(attack)
