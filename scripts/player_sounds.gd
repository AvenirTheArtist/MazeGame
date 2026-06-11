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
	
func randp_play(sound_name: String, minp: float = 1.1, maxp: float = 1.2):
	var sound_to_play = all_sounds[str(sound_name).to_lower()]
	if sound_to_play.playing:
		return

	sound_to_play.pitch_scale = randf_range(minp, maxp)
	sound_to_play.play()

func stop_playing(sound_name: String):
	var sound_to_stop = all_sounds[str(sound_name).to_lower()]
	if sound_to_stop.playing:
		sound_to_stop.stop()
