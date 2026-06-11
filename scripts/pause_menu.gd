extends Control


func resume():
	get_tree().paused = false
	print("resumed")

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func restart():
	get_tree().change_scene_to_packed(Global.MAZE_LEVEL)

func options():
	get_tree().current_scene.add_child(Global.OPTIONS_MENU.instantiate())

func menu():
	get_tree().change_scene_to_packed(Global.MAIN_MENU)
	
func testesc():
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _process(delta: float) -> void:
	pass
	#testesc()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	restart()

func _on_options_pressed() -> void:
	options()

func _on_quit_pressed() -> void:
	menu()
