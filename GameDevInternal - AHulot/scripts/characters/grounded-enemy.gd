extends CharacterBody2D

@export var GRAVITY : int = 10
@export var SPEED : int = 30
@export var MAX_HEALTH : int = 10

@onready var player = get_node("/root/World/Player")

var health
var moving_right = true
var can_hit = false

enum { WANDER, CHASE, HIT }

var state = WANDER
var enemy_id


func _ready():
	health = MAX_HEALTH
	enemy_id = global_position
	
	set_meta("Enemy", 1)
	set_meta("Grounded", 2)


func _physics_process(_delta):
	match state:
		WANDER : wander_state()
		HIT : hit_state()
		CHASE : chase_state()
	
	apply_gravity()
	
	var health_comp = $HealthComponent
	health_comp.update_battlehealth()
	
	
func wander_state():
	apply_gravity()
	$AnimationPlayer.play("move")
	
	if moving_right:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED

	detect_should_turn()
	move_and_slide()
	
	
func attack_player():
	if can_hit:
		var hitbox = get_node("/root/World/Player/HitboxComponent")
		var attack = Attack.new()
		
		attack.attack_damage = 50
		hitbox.damage(attack)
		
		can_hit = false

		$AttackCooldown.start()

func chase_state():
	if is_instance_valid(player) and player.is_alive:
		apply_gravity()
		$AnimationPlayer.play("move")
		
		if can_hit:
			if player in $DetectRange.get_overlapping_bodies():
				attack_player()
	else:
		state = WANDER

func hit_state():
	
	if state != HIT:
		state = HIT
		$HitRecovery.start()
	
	$AnimationPlayer.play("hit")

	
func apply_gravity():
	velocity.y += GRAVITY
	

func _on_hit_recovery_timeout():
	state = WANDER


func detect_should_turn():
	if not $Ray_V.is_colliding() or $Ray_H.is_colliding() and is_on_floor():
		moving_right = !moving_right
		scale.x = -scale.x
		
		if state != WANDER:
			state = WANDER


func _on_detect_range_area_entered(_area):
	if !can_hit:
		can_hit = true
	if state != CHASE:
		state = CHASE


func _on_attack_cooldown_timeout():
	can_hit = true


func _on_detect_range_area_exited(_area):
	if can_hit:
		can_hit = false
	state = WANDER
