class_name Enemy
extends CharacterBody3D

enum states {
	ROAMING,
	ALERTED,
	CHASING,
	STUNNED
}
@export var speed = 9.0
@export var patrol_pos: Array[Vector3]
var alerted_pos: Vector3
var next_dest: Vector3

var state = states.ROAMING
var update_timer = 0.0
var stun_immunity = 0.0

@onready var player_proximity = $player_proximity_detection
@onready var nav = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	get_parent().bell_collected.connect(move_to_bell)
	for i in get_tree().get_nodes_in_group("patrol_marker"):
		patrol_pos.append(i.global_position)
	next_dest = update_roaming()

func _physics_process(delta: float) -> void:
	
	## tick it down, while this is more than 0 the ghost will not be stunned
	if stun_immunity > 0:
		stun_immunity -= delta
	
	#region /// updating navigation 
	match state:
		states.CHASING:
			update_timer -= delta
			if update_timer <= 0:
				next_dest = player.global_position
				var rand = randf_range(-0.1, 0.1)
				randomize()
				update_timer += 0.2 + rand
		
		#states.STUNNED:
			#next_dest = self.global_position
	#endregion
	
	nav.target_position = next_dest
	var next_pos = nav.get_next_path_position()
	var direction: Vector3
	direction.x = next_pos.x - global_position.x
	direction.z = next_pos.z - global_position.z
	
	var vel = direction.normalized() * speed
	velocity = vel
	
	move_and_slide()


func update_roaming() -> Vector3:
	var possible_points: Array[Vector3]
	for i in patrol_pos:
		if (i - self.global_position).length() > 4:
			possible_points.append(i)
	
	return possible_points.pick_random()

## move to a collected bell
func move_to_bell(pos) -> void:
	if state != states.CHASING:
		alerted_pos = pos
		state = states.ALERTED
		next_dest = alerted_pos

## TEST TEST TEST 5 seconds of stun is ok?
func get_stunned() -> void:
	if stun_immunity > 0: return
	player_proximity.get_child(0).disabled = true
	state = states.STUNNED
	var defined_pos = Vector3.ZERO
	while defined_pos == Vector3.ZERO:
		var i = patrol_pos.pick_random()
		var dist = (i - self.global_position).length()
		if dist > 10 and dist < 25:
			defined_pos = i
	next_dest = defined_pos
	stun_immunity = 15.0
	await get_tree().create_timer(
		5.0, false
	).timeout
	state = states.ROAMING
	player_proximity.get_child(0).disabled = false
	

## start chase when player_proximity_detection sees a player
func _on_player_proximity_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		state = states.CHASING


func _on_player_proximity_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and not state == states.STUNNED:
		next_dest = update_roaming()
		state = states.ROAMING

## when the enemy in roaming or alerted state reaches something, it picks another point to roam towards 
func _on_navigation_agent_3d_target_reached() -> void:
	#print("reached")
	match state:
		states.ROAMING:
			next_dest = update_roaming()
		states.ALERTED:
			next_dest = update_roaming()
			state = states.ROAMING

## kill the player
func _on_kill_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and state != states.STUNNED:
		player.die()
