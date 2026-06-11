class_name Enemy
extends CharacterBody3D

enum states {
	ROAMING,
	ALERTED,
	CHASING,
	STUNNED
}

@export var sprites: Array[Texture2D] = [null, null]

@export var roam_speed: float
@export var alert_speed: float
@export var chase_speed: float
@export var stun_speed: float
@export var patrol_pos: Array[Vector3]
var alerted_pos: Vector3
var next_dest: Vector3

var state = states.ROAMING
var player_in_range = false
var update_timer = 0.0
var stun_immunity = 0.0

@onready var ghost_sprite: Sprite3D = $ghost_sprite
@onready var player_proximity = $player_proximity_detection
@onready var los_ray = $los_detection
@onready var nav = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sound_player: Node3D = $sound_player
var all_sounds: Dictionary


func _ready() -> void:
	Global.enemy = self
	for child in sound_player.get_children():
		if child is AudioStreamPlayer3D:
			all_sounds[child.name.to_lower()] = child

	get_parent().bell_collected.connect(move_to_bell)
	for i in get_tree().get_nodes_in_group("patrol_marker"):
		patrol_pos.append(i.global_position)
	next_dest = update_roaming()

func _physics_process(delta: float) -> void:
	if !all_sounds["proximity_sound"].playing:
		all_sounds["proximity_sound"].play()

	#region LOS
	## TEST /// LOS detection code ///
	if player_in_range:
		los_ray.look_at(player.global_position)
		if los_ray.is_colliding():
			if los_ray.get_collider() is Player and state != states.CHASING and state != states.STUNNED:
				state = states.CHASING
				all_sounds["alerted_scream"].play()
				#print("found")
	#endregion

	#TEMPORARY
	if Input.is_action_just_pressed("ui_accept"):
		move_to_player()

	## tick it down, while this is more than 0 the ghost will not be stunned
	if stun_immunity > 0:
		stun_immunity -= delta

	var speed_final: float
	#region /// updating navigation
	match state:
		states.ROAMING:
			ghost_sprite.texture = sprites[0]
			speed_final = roam_speed
		states.ALERTED:
			ghost_sprite.texture = sprites[0]
			speed_final = alert_speed
		states.CHASING:
			ghost_sprite.texture = sprites[0]
			speed_final = chase_speed
			update_timer -= delta
			if update_timer <= 0 and state == states.CHASING:
				next_dest = player.global_position
				var rand = randf_range(-0.1, 0.1)
				randomize()
				update_timer += 0.2 + rand
		states.STUNNED:
			ghost_sprite.texture = sprites[1]
			speed_final = stun_speed
	#endregion

	nav.target_position = next_dest
	var next_pos = nav.get_next_path_position()
	var direction: Vector3
	direction.x = next_pos.x - global_position.x
	direction.z = next_pos.z - global_position.z

	var vel = direction.normalized() * speed_final
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
	if state != states.CHASING and state != states.STUNNED:
		alerted_pos = pos
		state = states.ALERTED
		all_sounds["alerted_scream"].play()
		next_dest = alerted_pos

func move_to_player():
	if state != states.CHASING and state != states.STUNNED:
		alerted_pos = player.global_position
		state = states.ALERTED
		all_sounds["alerted_scream"].play()
		next_dest = alerted_pos

## TEST TEST TEST changed stun duration to 3s
func get_stunned() -> void:
	if stun_immunity > 0: return
	player_proximity.get_child(0).disabled = true
	state = states.STUNNED
	all_sounds["stunned"].play()
	var defined_pos = Vector3.ZERO
	while defined_pos == Vector3.ZERO:
		var i = patrol_pos.pick_random()
		var dist = (i - self.global_position).length()
		if dist > 20 and dist < 40:
			defined_pos = i
	next_dest = defined_pos
	stun_immunity = 6.0
	await get_tree().create_timer(
		3.0, false
	).timeout
	state = states.ROAMING
	player_proximity.get_child(0).disabled = false


## start chase when player_proximity_detection sees a player


func _on_player_proximity_detection_body_entered(body: Node3D) -> void:
	if state == states.STUNNED:
		return
	if body.is_in_group("player"):
		if state == states.ROAMING:
			state = states.CHASING
			all_sounds["alerted_scream"].play()
			player_in_range = true
		elif state == states.ALERTED:
			state = states.CHASING
			player_in_range = true


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
