class_name PlayerSounds
extends AudioListener3D

var all_sounds: Dictionary

func _ready() -> void:
	Global.player_sounds = self
	
	for child in get_children():
		if child is AudioStreamPlayer3D:
			all_sounds[child.name.to_lower()] = child
		
		

func play(sound_name: String):
	var sound_to_play = all_sounds[str(sound_name).to_lower()]
	if sound_to_play.playing:
		return
	sound_to_play.play()
	
func rand_play(sound_name: String, min: float = 1.1, max: float = 1.2):
	var sound_to_play = all_sounds[str(sound_name).to_lower()]
	if sound_to_play.playing:
		return

	sound_to_play.pitch_scale = randf_range(min, max)
	sound_to_play.play()
	
