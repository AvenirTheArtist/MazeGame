class_name Player
extends CharacterBody3D


@export var max_hp = 100.0
var hp = max_hp
@export var walk_speed = 5.0
@export var sprint_speed = 9.0
@export var acceleration = 10.0
@export var max_stamina = 100.0
var stamina = max_stamina
@export var stamina_drain = 30.0
@export var stamina_recovery = 7.0

@export var sensitivity = 0.1

var sprinting = false
var death_animation = false

var lantern_empowered = false
var lantern_time: float = 20
var ghost_in_range = false
var distance_from_ghost: float

var BOB_FREQ := 2.0
var BOB_AMP := 0.04
var t_bob := 0.0

var matchstick_amount: int = 2

@onready var ghost = get_tree().get_first_node_in_group("ghost")
@onready var head = $head
@onready var light_lantern = $OmniLight3D
@onready var gui = $head/gui
@onready var lantern_hitbox = $head/stun_area/CollisionShape3D
@onready var los_ray = $head/stun_area/los_detection_ray

func _ready() -> void:
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func _process(_delta: float) -> void:
	sensitivity = Global.sensitivity
	
	#GLITCH SHADER
	distance_from_ghost = global_position.distance_to(Global.enemy.global_position)
	var jitshader_value: float =  0.05 - distance_from_ghost/300
	jitshader_value = clampf(jitshader_value, 0.001, 0.05)
	
	
	gui.glitchshader.material.set_shader_parameter("chromatic_aberration_strength", jitshader_value)
	gui.glitchshader.material.set_shader_parameter("jitter_amount", jitshader_value)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()
	
	t_bob += velocity.length() * delta * float(is_on_floor())
	head.transform.origin = _headbob(t_bob)
	
	light_lantern.light_energy = clampf(light_lantern.light_energy, 1, 99)
	
	## LOS detection for lantern stun
	if ghost_in_range:
		los_ray.look_at(ghost.global_position)
		if los_ray.is_colliding():
			if los_ray.get_collider() is Enemy:
				ghost.get_stunned()
	
	## /// beginning of movement
	if death_animation: return # disable all of it if you're caught
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = input_dir.normalized().rotated(-head.rotation.y)
	var direction_final = Vector3(direction.x, 0, direction.y)
	
	var speed: float
	if sprinting:
		speed = sprint_speed
	else:
		speed = walk_speed
	
		## sprinting
	if Input.is_action_just_pressed("sprint"):
		sprinting = true
	if Input.is_action_just_released("sprint"):
		sprinting = false
	
	if sprinting and direction_final.length() > 0.1:
		stamina -= stamina_drain * delta
		if stamina <= 0:
			sprinting = false
	else:
		if stamina < max_stamina:
			stamina += stamina_recovery * delta
	
	velocity.x = lerp(velocity.x, speed * direction_final.x, acceleration * delta)
	velocity.z = lerp(velocity.z, speed * direction_final.z, acceleration * delta)
	## /// end of movement
	move_and_slide()

## rotate camera
func _input(event) -> void:
	if event is InputEventMouseMotion and not death_animation:
		head.rotation_degrees.y -= event.relative.x * sensitivity
		head.rotation_degrees.x -= event.relative.y * sensitivity
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func change_lantern_brightness(value: float) -> void:
	light_lantern.light_energy += value

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = (sin(time * BOB_FREQ) * BOB_AMP) + 0.5
	if sin(time * BOB_FREQ) <= -0.99 and !Global.player_sounds.all_sounds["footstep"].playing:
		Global.player_sounds.randp_play("footstep", 0.2, 0.5)
	return pos

## when the ghost touches you this finds ghost's head position
## and your camera snaps to its head pos for a "jumpscare"
func die() -> void:
	Global.player_sounds.play("jumpscare")
	for i in 5: 
		gui.get_child(i + 2).hide()
	var look_pos: Vector3
	look_pos = ghost.global_position
	look_pos.y += 1.0
	head.position.y = 1.0
	death_animation = true
	lantern_empowered = false
	Global.enemy.state = Global.enemy.states.ALERTED
	head.look_at(look_pos)
	await get_tree().create_timer(
		2.0,
		false
	).timeout
	# show a death screen
	get_tree().change_scene_to_file("res://death_screen.tscn") 
	

## these two are for checking ghost within light's hitbox logic
func _on_stun_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("ghost"):
		ghost_in_range = true

func _on_stun_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("ghost"):
		ghost_in_range = false

func pause():
	var new_pausemenu = Global.PAUSE_MENU.instantiate()
	get_tree().current_scene.add_child(new_pausemenu)
