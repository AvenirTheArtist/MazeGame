extends Pickup

## code goes here
func picked_up() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.matchstick_amount += 1
	print("picked up match")
	queue_free()
