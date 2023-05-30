extends CharacterBody2D


@export var GRAVITY: int = 10

func _physics_process(delta):
	apply_gravity()
	
	move_and_slide()
	$AnimationPlayer.play("move")

func apply_gravity():
	velocity.y += GRAVITY
