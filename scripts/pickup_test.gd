extends Pickup


func picked_up() -> void:
	print("picked up")
	queue_free()
