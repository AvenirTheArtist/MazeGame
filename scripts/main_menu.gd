extends Control

@onready var buttons = {
	"enter": $VBoxContainer/Enter,
	"options": $VBoxContainer/Options,
	"quit": $VBoxContainer/Quit
	
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false

func _process(_delta: float) -> void:
	if !$ambience.playing:
		$ambience.play()


func _on_enter_pressed() -> void:
	get_tree().change_scene_to_packed(Global.MAZE_LEVEL)

func _on_options_pressed() -> void:
	get_tree().current_scene.add_child(Global.OPTIONS_MENU.instantiate())
func _on_quit_pressed() -> void:
	get_tree().quit()
