extends Pickup

var activated = false

func _ready() -> void:
	get_parent().number_of_bells += 1

func _process(delta: float) -> void:
	if not activated:
		if !$ambience.playing:
			$ambience.play()

func picked_up() -> void:
	if not activated:
		get_parent().bells_collected += 1
		$bellring.play()
		$ambience.stop()
		$bell2.get_node("AnimationPlayer").play("swinging")
		get_parent().bell_collected.emit(self.global_position)
		activated = true
