extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.sound_enabled and not $music.playing:
		$music.play()


func play_sound(sound):
	if global.sound_enabled:
		match sound:
			"player_jump" : $player_jump.play()
			"player_death" : $player_death.play()
			"player_shoot" : $player_shoot.play()
			"enemy_death" : $enemy_death.play()
			"camp_int" : $camp_int.play()
			"ship_int" : $ship_int.play()
			"part_collect" : $part_collect.play()
			"orb_collect" : $orb_collect.play()
			"button_press" : $button_press.play()
	else:
		pass

func stop_all():
	var audio_players = get_tree().get_nodes_in_group("Audio")
	
	for audio_player in audio_players:
		audio_player.stop()
