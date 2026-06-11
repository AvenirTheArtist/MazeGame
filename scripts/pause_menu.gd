extends Control


func resume():
	queue_free()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func restart():
	get_tree().change_scene_to_file("res://maps/maze_level.tscn")

func options():
	get_tree().current_scene.add_child(Global.OPTIONS_MENU.instantiate())

func menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
func testesc():
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _process(_delta: float) -> void:
	testesc()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	restart()

func _on_options_pressed() -> void:
	options()

func _on_quit_pressed() -> void:
	menu()
