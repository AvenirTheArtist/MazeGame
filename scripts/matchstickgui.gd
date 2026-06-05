extends TextureRect

@onready var fireanim: AnimatedSprite2D = $fireanim
@onready var burnouttimer: Timer = $burnouttimer

@export var matchstick_health: float = 2

var burning: bool = false
enum stages {UNLIT, LIT, HALFWAY_LIT, NONE}
var current_stage: stages = stages.UNLIT

func _ready() -> void:
	start_burning()

func start_burning():
	burnouttimer.start()
	current_stage = stages.LIT
	burning = true
	fireanim.play("enterfire")
	await fireanim.animation_finished
	fireanim.play("animatedfire")

func burnout():
	current_stage = stages.UNLIT
	fireanim.play("empty")
	print("action")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_burning()
		
		
	match current_stage:
		stages.LIT:
			pass
		stages.HALFWAY_LIT:
			pass
		stages.UNLIT:
			pass
		stages.NONE:
			pass


func _on_burnouttimer_timeout() -> void:
	burnout()
	print("burnout")
