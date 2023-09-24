extends Control

var parts_progress = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	parts_progress = ""
	
	# Display in format: #Collected / #Total Parts.
	for type in global.required_parts.keys():
		parts_progress += str(player_vars.collected_parts[type]) + " / " + str(global.required_parts[type]) + "\n"
	
	$Resources.text = parts_progress
	
	if Input.is_action_just_pressed("ui_inventory"):
		if is_visible():
			hide()
		else:
			show()
		
