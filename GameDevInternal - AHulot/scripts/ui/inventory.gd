extends Control

@onready var player = get_node("/root/World/Player")
@onready var ship = get_node_or_null("/root/World/Ship")

var parts_progress = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if ship != null:
		
		parts_progress = ""
		
		for type in ship.required_parts.keys():
			parts_progress += str(player.collected_parts[type]) + " / " + str(ship.required_parts[type]) + "\n"
		
		$Resources.text = parts_progress
		
		if !is_visible():
			if Input.is_action_just_pressed("ui_inventory"):
				show()
		else:
			if Input.is_action_just_pressed("ui_inventory"):
				hide()
