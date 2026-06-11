extends Control

@export
var bus_name: String
var bus_index: int

@onready var audio_slider: HSlider = $CanvasLayer/VBoxContainer/Audio/audio_slider
@onready var sens_slider: HSlider = $CanvasLayer/VBoxContainer/Sensitivity/sens_slider


func _ready() -> void:
	#VOLUME
	bus_index = AudioServer.get_bus_index(bus_name)
	audio_slider.value_changed.connect(_on_vol_changed)
	audio_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	#SENSITIVITY
	sens_slider.value_changed.connect(_on_sens_changed)
	sens_slider.value = Global.sensitivity
	
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("pause"):
		queue_free()

func _on_vol_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
func _on_sens_changed(value: float) -> void:
	Global.sensitivity = value

func _on_back_pressed() -> void:
	queue_free()
