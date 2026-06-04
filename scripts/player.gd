class_name Player
extends CharacterBody3D


@export var max_hp = 100.0
var hp = max_hp
@export var speed = 5.0
@export var friction = 20.0
@export var acceleration = 10.0
@export var air_control = 3.0
@export var jump_vel = 5.0
@export var gravity = 9.8

@export var sensitivity = 0.1

@onready var head = $head

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	## /// beginning of movement
	## this code tries to emulate source engine movement so airstrafe is very well possible
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = input_dir.normalized().rotated(-head.rotation.y)
	var pre_direction = Vector3(direction.x, 0, direction.y)
	var direction_final: Vector3
	direction_final = pre_direction
	if not is_on_floor():
		if (
		pre_direction.normalized().x == -velocity.normalized().x
		) and pre_direction.normalized().z == -velocity.normalized().z:
			direction_final = Vector3(0, 0, 0)
	var min_speed = direction_final.normalized().length()
	if min_speed > 0.5:
		min_speed = 0.5
	
	var current_speed = velocity.dot(direction_final)
	var add_speed = min_speed - current_speed
	

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_vel
	
	if is_on_floor():
		if current_speed < speed:
			velocity.x = lerp(velocity.x, speed * direction_final.x, acceleration * delta)
			velocity.z = lerp(velocity.z, speed * direction_final.z, acceleration * delta)
		else:
			velocity.x -= velocity.x * friction * delta
			velocity.z -= velocity.z * friction * delta
		
	else:
		if add_speed > 0:
			velocity.x += add_speed / air_control * direction_final.x
			velocity.z += add_speed / air_control * direction_final.z
	
	## /// end of movement
	
	move_and_slide()

## rotate camera
func _input(event):
	if event is InputEventMouseMotion:
		head.rotation_degrees.y -= event.relative.x * sensitivity
		head.rotation_degrees.x -= event.relative.y * sensitivity
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func take_damage(damage_taken: float) -> void:
	hp -= damage_taken
	if hp <= 0:
		die()

func die() -> void:
	## need a proper death code 
	pass
