extends Node

@warning_ignore("unused_signal")
signal bell_collected(pickup_pos)

@export var number_of_bells: int
var bells_collected = 0

func _process(_delta: float) -> void:
	if bells_collected >= 7:
		get_tree().change_scene_to_file("res://youwin.tscn")
