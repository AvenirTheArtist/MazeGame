extends TextureRect

@onready var animsprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var burnouttimer: Timer = $burnouttimer

var burning: bool = false
enum stages {UNLIT, LIT, HALFWAY_LIT, BURNT_OUT}
var current_stage: stages = stages.UNLIT

func _ready() -> void:
	start_burning()

func start_burning():
	current_stage = stages.LIT
	burning = true
	animsprite.play("animatedfire")

func _process(delta: float) -> void:
	match current_stage:
		stages.LIT:
			pass
		stages.UNLIT:
			pass
		stages.HALFWAY_LIT:
			pass
		stages.BURNT_OUT:
			pass
