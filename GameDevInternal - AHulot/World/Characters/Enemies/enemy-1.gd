extends CharacterBody2D

@export var GRAVITY: int = 10
@export var SPEED: int = 80
@export var MAX_HEALTH: int = 10

@onready var player = get_node("/root/World/Player")

var health
var moving_right = true

enum { WANDER, CHASE, HIT }

var state = WANDER


func _ready():
	health = MAX_HEALTH


func _physics_process(delta):
	match state:
		WANDER : wander_state()
		CHASE : chase_state()
		HIT : hit_state()
	
	apply_gravity()
	
	
func wander_state():
	apply_gravity()
	$AnimationPlayer.play("move")
	
	if moving_right:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED

	detect_should_turn()
	move_and_slide()


func chase_state():
	apply_gravity()
	move_and_slide()
	
	state = WANDER
	
#	$AnimationPlayer.play("move")
#
#	var direction = Vector2.ZERO
#	var locate = sign(player.global_position.x - global_position.x)
#
#	if locate > 5:
#		direction = Vector2.RIGHT
#		moving_right = true
#	elif locate < 5:
#		direction = Vector2.LEFT
#		moving_right = false
#	else:
#		direction = Vector2.ZERO
#
#	if direction:
#		velocity.x = direction.x * SPEED
#		detect_should_turn()
#		move_and_slide()


func hit_state():
	
	if state != HIT:
		state = HIT
		$HitRecovery.start()
	
	$AnimationPlayer.stop()

	
func apply_gravity():
	velocity.y += GRAVITY	


func _on_detect_range_body_entered(body):
	if body == player:
		state = CHASE


func _on_detect_range_body_exited(body):
	if body == player:
		state = WANDER


func _on_hit_recovery_timeout():
	state = WANDER


func detect_should_turn():
	if not ($Ray_V.is_colliding() or $Ray_H.is_colliding()) and is_on_floor():
		moving_right = !moving_right
		scale.x = -scale.x
		
		if state != WANDER:
			state = WANDER
