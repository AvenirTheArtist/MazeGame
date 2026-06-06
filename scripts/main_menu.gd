extends Control

@export var level: PackedScene
@onready var buttons = {
	"start": $VBoxContainer/start,
	"leave": $VBoxContainer/leave
}


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(level)


func _on_leave_pressed() -> void:
	get_tree().quit()
