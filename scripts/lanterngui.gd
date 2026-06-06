extends TextureRect

enum stages {UNLIT, LIT, DYING, OTHER}

@export var lantern_textutes: Array[Texture2D] = [null, null]
@export var lantern_health: float = 20
@export var empowered_strength: float = 20

@onready var fireanim: AnimatedSprite2D = $fireanim
@onready var burnouttimer: Timer = $burnouttimer
@onready var matchstick: TextureRect = $"../../bottomleft/matchstickgui"
@onready var lanternanim: AnimationPlayer = $"../../lanternanim"

var current_stage: stages = stages.UNLIT
var lanternburning: bool = false


func _ready() -> void:
	lanternanim.play("lanterngoingup")
	
func _process(_delta: float) -> void:
	

	if Input.is_action_just_pressed("lantern"):
		start_buring()
		
	if burnouttimer.time_left <= Global.player.lantern_time * 2/3 and burnouttimer.time_left != 0:
		if current_stage != stages.DYING:
			start_dying()
		else: pass
	
	
	
	match current_stage:
		stages.UNLIT:
			Global.player.lantern_empowered = false
			lanternburning = false
			fireanim.play("empty")
			texture = lantern_textutes[0]
		stages.LIT:
			Global.player.lantern_empowered = true
			lanternburning = true
			texture = lantern_textutes[1]
		stages.DYING:
			Global.player.lantern_empowered = false
			lanternburning = true
			texture = lantern_textutes[0]

		
func start_buring():
	if !matchstick.burning:
		return
	lanternanim.play("lanterngoingdown")
	lanternanim.queue("lanterngoingup")
	await lanternanim.animation_changed
	if current_stage == stages.UNLIT:
		Global.player.change_lantern_brightness(empowered_strength)
		current_stage = stages.LIT
	burnouttimer.start(lantern_health)
	

	
	fireanim.play("enterfire")
	await fireanim.animation_finished
	fireanim.play("animatedfire")

func start_dying():
	current_stage = stages.DYING
	Global.player.change_lantern_brightness(-empowered_strength * 2/3)

func burnout():
	Global.player.change_lantern_brightness(-empowered_strength * 1/3)
	current_stage = stages.UNLIT

func _on_burnouttimer_timeout() -> void:
	burnout()
