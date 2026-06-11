extends Node

var player = preload("uid://duti8b7dsrn3r")
var enemy: Enemy
var camera: Camera2D
var player_sounds: PlayerSounds

var sensitivity: float = 0.1
var fullscreen: bool = true

const MAIN_MENU = preload("uid://cmdj4mgmded3t")
const OPTIONS_MENU = preload("uid://cwporusy18ghv")
const PAUSE_MENU = preload("uid://iisaefqejfgo")
const MAZE_LEVEL = preload("uid://cn4nyp8cm2sml")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		print("pressed")
		if fullscreen:
			fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else: 
			fullscreen = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
