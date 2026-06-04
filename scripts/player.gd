class_name Player
extends CharacterBody3D


@export var max_hp = 100.0
var hp = max_hp
@export var walk_speed = 5.0
@export var sprint_speed = 9.0
@export var acceleration = 10.0
@export var max_stamina = 100.0
var stamina = max_stamina
@export var stamina_drain = 10.0
@export var stamina_recovery = 7.0

@export var sensitivity = 0.1

var sprinting = false

@onready var head = $head

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	## /// beginning of movement
	
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
