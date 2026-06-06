extends Pickup

func _ready() -> void:
	get_parent().number_of_bells += 1

func picked_up() -> void:
	get_parent().bells_collected += 1
	get_parent().bell_collected.emit(self.global_position)
	queue_free()
