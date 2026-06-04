class_name Enemy
extends CharacterBody3D

enum states {
	ROAMING,
	ALERTED,
	CHASING,
	STUNNED
}
@export var speed = 6.0
@export var patrol_pos: Array[Vector3]
var alerted_pos: Vector3

var state = states.ROAMING
var update_timer = 0.0

@onready var nav = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	get_parent().bell_collected.connect(move_to_bell)

func _physics_process(delta: float) -> void:
	
	## probably requires a state machine later, this works for testing for now	update_timer -= delta
	
	#region updating player position
	update_timer -= delta
	if update_timer <= 0:
		var rand = randf_range(-0.1, 0.1)
		randomize()
		update_timer += 0.2 + rand
		#print(next_dest)
		var next_dest: Vector3
		match state:
			states.ROAMING:
				pass
			states.ALERTED:
				next_dest = alerted_pos
			states.CHASING:
				next_dest = player.global_position
			states.STUNNED:
				next_dest = self.global_position
		print(next_dest)
		#endregion
		
		nav.target_position = next_dest
	var next_pos = nav.get_next_path_position()
	var direction: Vector3
	direction.x = next_pos.x - global_position.x
	direction.z = next_pos.z - global_position.z
	
	var vel = direction.normalized() * speed
	velocity = vel
	
	move_and_slide()


func move_to_bell(pos) -> void:
	alerted_pos = pos
	state = states.ALERTED
