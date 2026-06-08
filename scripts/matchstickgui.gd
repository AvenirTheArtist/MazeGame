extends TextureRect

enum stages {UNLIT, LIT, HALFWAY_LIT, NONE}

@export var matchstick_textures: Array[Texture2D] = [null, null]
@export var matchstick_health: float = 2

@onready var fireanim: AnimatedSprite2D = $fireanim
@onready var matchstickanims: AnimationPlayer = $"../../matchstickanims"
@onready var burnouttimer: Timer = $burnouttimer

@onready var litpos: Control = $litpos
@onready var halfwaylitpos: Control = $halfwaylitpos

var burning: bool = false
var current_stage: stages = stages.UNLIT

var matchstick_strength: float = 3

func _ready() -> void:
	matchstickanims.play("matchcomingup")
	
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("matchstick"):
		start_burning()
	if Input.is_action_just_pressed("lantern"):
		light_lantern()
		
	if burnouttimer.time_left <= matchstick_health/2 and burnouttimer.time_left != 0:
		current_stage = stages.HALFWAY_LIT
		
	match current_stage:
		stages.LIT:
			burning = true
			fireanim.global_position = litpos.global_position
			texture = matchstick_textures[0]
		stages.HALFWAY_LIT:
			burning = true
			fireanim.global_position = halfwaylitpos.global_position
			texture = matchstick_textures[1]
		stages.UNLIT:
			burning = false
			texture = matchstick_textures[0]
			fireanim.play("empty")
		stages.NONE:
			if Global.player.matchstick_amount > 0:
				current_stage = stages.UNLIT
				grab_matchstick()
			burning = false
			fireanim.play("empty")
			texture = null
			
func grab_matchstick():
	matchstickanims.play("matchcomingup")

func start_burning() -> void:
	if burning == true:
		return
	if Global.player.matchstick_amount <= 0:
		return
	if current_stage == stages.LIT:
		Global.player.matchstick_amount -= 1
	matchstickanims.play("matchgoingdown")
	await matchstickanims.animation_finished
	Global.player_sounds.rand_play("click", 0.8, 1.3)
	Global.player_sounds.rand_play("start_burning", 0.8, 1.2)
	matchstickanims.play("matchcomingup")

	burnouttimer.start(matchstick_health)
	current_stage = stages.LIT
	Global.player.change_lantern_brightness(matchstick_strength)
	
	fireanim.play("enterfire")
	await fireanim.animation_finished
	fireanim.play("animatedfire")

func burnout() -> void:
	Global.player.change_lantern_brightness(-matchstick_strength)
	current_stage = stages.NONE
	fireanim.play("empty")
	Global.player.matchstick_amount -= 1
	Global.player.gui.change_matches_count(Global.player.matchstick_amount)
	if Global.player.matchstick_amount >= 1:
		current_stage = stages.UNLIT
		matchstickanims.play("matchcomingup")
	
func light_lantern():
	if burning == false:
		return
	matchstickanims.play("matchgoingdown")
	await matchstickanims.animation_finished
	burnouttimer.stop()
	burnouttimer.timeout.emit()

func _on_burnouttimer_timeout() -> void:
	burnout()
