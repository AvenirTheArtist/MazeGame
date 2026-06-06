extends Pickup

## code goes here
func picked_up() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player.matchstick_amount < 1:
		player.gui.animplayer.play("matchcomingup")
		player.gui.bottomleft.matchstick.current_stage = player.gui.bottomleft.matchstick.stages.UNLIT
	player.matchstick_amount += 1
	print("picked up match")
	queue_free()
