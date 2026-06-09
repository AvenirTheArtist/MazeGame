extends Pickup

var activated = false

func _ready() -> void:
	get_parent().number_of_bells += 1

func picked_up() -> void:
	if not activated:
		get_parent().bells_collected += 1
		$AudioStreamPlayer3D.play()
		$bell2.get_node("AnimationPlayer").play("swinging")
		get_parent().bell_collected.emit(self.global_position)
		activated = true
