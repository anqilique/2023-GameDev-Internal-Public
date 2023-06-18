extends CharacterBody2D

@onready var timer = get_node("/root/World/Orbs/Timer")

var spawn_pos = Vector2.ZERO
var orb_energy = 5
var orb_health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_visible():
		if !is_on_floor():
			apply_gravity()
		else:
			apply_friction()
		move_and_slide()

func wait_spawn(pos):
	spawn_pos = pos
	timer.start()

func spawn():
	print(spawn_pos)
	$SpawnPos.global_position = spawn_pos
	
	var orbs = [0, 1]
	
	for i in range(2):
		var new_orb = duplicate()
		self.add_sibling(new_orb)
		
		$Orb.frame = orbs[(i - 1)]

		new_orb.position = spawn_pos
		new_orb.velocity.y -= randi_range(100, 150)
		
		var direction = randi_range(-1, 1)
		new_orb.velocity.x += randi_range(25, 50) * direction
		
		new_orb.show()

func _on_timer_timeout():
	print(">> Enemy drops Orbs.")
	spawn()

func apply_gravity():
	velocity.y += 10

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, 10)


func _on_collect_range_body_entered(body):
	var player = get_node("/root/World/Player")
	
	if $Orb.frame == 0:
		print(">> Player Collects Health Orb")
		player.collect_orb("Health")
	else:
		print(">> Player Collects Energy Orb")
		player.collect_orb("Energy")
	
	self.queue_free()
