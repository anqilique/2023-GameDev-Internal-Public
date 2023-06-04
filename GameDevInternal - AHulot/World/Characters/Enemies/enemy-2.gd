extends CharacterBody2D

@export var GRAVITY: int = 10
@export var speed_div: int = 40
@export var MAX_HEALTH: int = 10

@onready var player = get_node("/root/World/Player")

var health
var player_chase = false

enum { WANDER, CHASE, HIT }

var state = WANDER


func _ready():
	health = MAX_HEALTH
	$AnimationPlayer.play("move")


func _physics_process(delta):
	match state:
		WANDER : wander_state()
		CHASE : chase_state()
		HIT : hit_state()

func wander_state():
	# state = CHASE
	pass

func chase_state():
	$AnimationPlayer.play("move")
	position += (player.position - position) / speed_div


func hit_state():
	
	if state != HIT:
		state = HIT
		$HitRecovery.start()
	
	$AnimationPlayer.play("hit")
	print(player.position)
	

func _on_detect_range_body_entered(body):
	if body == player:
		state = CHASE

func _on_detect_range_body_exited(body):
	if body == player:
		state = WANDER

func _on_hit_recovery_timeout():
	state = WANDER

func _on_body_area_body_entered(body):
	if body != player:
		speed_div += 100

func _on_body_area_body_exited(body):
	if body != player:
		speed_div -= 100
		
