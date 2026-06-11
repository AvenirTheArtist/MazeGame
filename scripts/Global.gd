extends Node

var player = preload("uid://duti8b7dsrn3r")
var enemy: Enemy
var camera: Camera2D
var player_sounds: PlayerSounds

var sensitivity: float = 0.1

const MAIN_MENU = preload("uid://cmdj4mgmded3t")
const OPTIONS_MENU = preload("uid://cwporusy18ghv")
const PAUSE_MENU = preload("uid://iisaefqejfgo")
const MAZE_LEVEL = preload("uid://cn4nyp8cm2sml")
