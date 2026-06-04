class_name Pickup
extends Area3D

## does something when an item is walked over by player


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		picked_up()

## overridable func, called when player touches it
func picked_up() -> void:
	pass
