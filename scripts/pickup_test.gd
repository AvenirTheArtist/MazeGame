extends Pickup


func picked_up() -> void:
	print("picked up")
	get_parent().bells_collected += 1
	get_parent().bell_collected.emit()
	queue_free()
