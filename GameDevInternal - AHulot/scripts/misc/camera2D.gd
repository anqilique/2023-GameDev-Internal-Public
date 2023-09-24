extends Camera2D

@export var random_strength : float = 5.0
@export var shake_fade : float = 20

var random = RandomNumberGenerator.new()
var shake_strength : float = 0.0


func _physics_process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()


func apply_shake():
	shake_strength = random_strength


func random_offset():
	var offset_x = random.randf_range(-shake_strength, shake_strength)
	var offset_y = random.randf_range(-shake_strength, shake_strength)
	
	return Vector2(offset_x, offset_y)
