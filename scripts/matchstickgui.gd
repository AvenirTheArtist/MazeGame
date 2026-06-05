extends TextureRect

enum stages {UNLIT, LIT, HALFWAY_LIT, NONE}

@export var matchstick_textures: Array[Texture2D] = [null, null]
@export var matchstick_health: float = 2

@onready var fireanim: AnimatedSprite2D = $fireanim
@onready var animplayer: AnimationPlayer = $"../../AnimationPlayer"
@onready var burnouttimer: Timer = $burnouttimer

@onready var litpos: Control = $litpos
@onready var halfwaylitpos: Control = $halfwaylitpos

var burning: bool = false
var current_stage: stages = stages.UNLIT



func _ready() -> void:
	animplayer.play("matchcomingup")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_burning()
		
	if burnouttimer.time_left <= matchstick_health/2 and burnouttimer.time_left != 0:
		current_stage = stages.HALFWAY_LIT
		
	match current_stage:
		stages.LIT:
			fireanim.global_position = litpos.global_position
			texture = matchstick_textures[0]
		stages.HALFWAY_LIT:
			fireanim.global_position = halfwaylitpos.global_position
			texture = matchstick_textures[1]
		stages.UNLIT:
			texture = matchstick_textures[0]
			fireanim.play("empty")
		stages.NONE:
			fireanim.play("empty")
			texture = null
			
func start_burning():
	if Global.player.matchstick_amount <= 0:
		return
	burnouttimer.start(matchstick_health)
	current_stage = stages.LIT
	burning = true
	
	fireanim.play("enterfire")
	await fireanim.animation_finished
	fireanim.play("animatedfire")

func burnout():
	burning = false
	current_stage = stages.NONE
	fireanim.play("empty")
	Global.player.matchstick_amount -= 1
	if Global.player.matchstick_amount >= 1:
		current_stage = stages.UNLIT
		animplayer.play("matchcomingup")
	else: current_stage = stages.NONE

func _on_burnouttimer_timeout() -> void:
	burnout()
