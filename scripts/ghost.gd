class_name Enemy
extends CharacterBody3D


@export var speed = 6.0

var update_timer = 0.0

@onready var nav = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	
	## probably requires a state machine later, this works for testing for now
	#region updating player position
	update_timer -= delta
	if update_timer <= 0:
		var rand = randf_range(-0.1, 0.1)
		randomize()
		update_timer += 0.2 + rand
		var next_dest = player.global_position
		nav.target_position = next_dest
		#print(next_dest)
	#endregion
	var next_pos = nav.get_next_path_position()
	#look_target = next_pos
	var direction: Vector3
	direction.x = next_pos.x - global_position.x
	direction.z = next_pos.z - global_position.z
	
	var vel = direction.normalized() * speed
	velocity = vel
	
	move_and_slide()
