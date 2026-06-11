extends Control

@export var level: PackedScene
@export var options_menu: PackedScene
@onready var buttons = {
	"enter": $VBoxContainer/Enter,
	"options": $VBoxContainer/Options,
	"quit": $VBoxContainer/Quit
	
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_enter_pressed() -> void:
	get_tree().change_scene_to_packed(level)

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
