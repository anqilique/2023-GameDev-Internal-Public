extends Node2D

var light_cost
var can_regen
var flame_state

# Called when the node enters the scene tree for the first time.
func _ready():
	$Flame.hide()
	flame_state = 0
	light_cost = 0
	can_regen = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("/root/World/Player")
	light_cost = flame_state * 2
	
	if flame_state > 0:
		$Flame.show()
		$Flame/AnimationPlayer.play(str(flame_state - 1))
	else:
		$Flame.hide()
		can_regen = false
	
	if Input.is_action_just_pressed("ui_interact"):
		player.spawn_point = position
		
		if player.energy > light_cost and player in $Range.get_overlapping_bodies():
			if flame_state < 8:
				player.energy -= light_cost
				
				if $Flame.is_visible():
					flame_state += 1
					$Regen.start()
					$Shrink.start()
				else:
					flame_state = 1
					$Regen.start()
					$Shrink.start()
	
	if $Flame.is_visible() and player in $Range.get_overlapping_bodies():
		if can_regen:
			player.regenerate()
			can_regen = false
			$Regen.start()

func _on_shrink_timeout():
	if flame_state >= 1:
		flame_state -= 1

func _on_regen_timeout():
	can_regen = true
