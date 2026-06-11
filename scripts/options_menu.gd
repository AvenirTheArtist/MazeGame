extends Control

@export
var bus_name: String
var bus_index: int

@onready var volume: HSlider = $CanvasLayer/VBoxContainer/volume

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	volume.value_changed.connect(_on_value_changed)
	volume.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
	
func _on_back_pressed() -> void:
	queue_free()
