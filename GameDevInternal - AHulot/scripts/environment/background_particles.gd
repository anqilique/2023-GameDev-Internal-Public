extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.time_left <= 100:
		$CPUParticles2D.speed_scale = 6
	elif global.time_left <= 200:
		$CPUParticles2D.speed_scale = 5
	elif global.time_left <= 300:
		$CPUParticles2D.speed_scale = 4
	elif global.time_left <= 400:
		$CPUParticles2D.speed_scale = 3
	elif global.time_left <= 500:
		$CPUParticles2D.speed_scale = 2
	else:
		$CPUParticles2D.speed_scale = 1
