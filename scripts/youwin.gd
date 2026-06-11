extends Control

@onready var timer: Timer = $Timer

func _ready() -> void:
	$harp.play()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
