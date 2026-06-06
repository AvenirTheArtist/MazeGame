extends ColorRect


func _ready() -> void:
	await get_tree().create_timer(
		5.0, false
	).timeout
	get_tree().change_scene_to_file("res://main_menu.tscn")
