extends Control

@export
var bus_name: String
var bus_index: int

@onready var audio_slider: HSlider = $CanvasLayer/VBoxContainer/Audio/audio_slider
@onready var sens_slider: HSlider = $CanvasLayer/VBoxContainer/Sensitivity/sens_slider
@onready var fullscreen: CheckBox = $CanvasLayer/VBoxContainer/checkboxes/fullscreen


func _ready() -> void:
	#VOLUME
	bus_index = AudioServer.get_bus_index(bus_name)
	audio_slider.value_changed.connect(_on_vol_changed)
	audio_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	#SENSITIVITY
	sens_slider.value_changed.connect(_on_sens_changed)
	sens_slider.value = Global.sensitivity
	
	#RESOLUTION:
	fullscreen.button_pressed = Global.fullscreen
	
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("pause"):
		queue_free()

func _on_vol_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_sens_changed(value: float) -> void:
	Global.sensitivity = value

func _on_back_pressed() -> void:
	queue_free()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.fullscreen = true
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.fullscreen = false

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1792, 1008))
		2:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		3:
			DisplayServer.window_set_size(Vector2i(1536, 864))
		4:
			DisplayServer.window_set_size(Vector2i(1408, 792))
		5:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		6:
			DisplayServer.window_set_size(Vector2i(1152, 648))
		7:
			DisplayServer.window_set_size(Vector2i(1024, 576))
