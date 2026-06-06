extends TextureRect

enum stages {UNLIT, LIT, DYING, OTHER}

@export var lantern_textutes: Array[Texture2D] = [null, null]
@export var lantern_health: float = 5.0

@onready var fireanim: AnimatedSprite2D = $fireanim
@onready var burnouttimer: Timer = $burnouttimer
@onready var matchstick: TextureRect = $"../../bottomleft/matchstickgui"
@onready var lanternanim: AnimationPlayer = $"../../lanternanim"

var current_stage: stages = stages.UNLIT
var lanternburning: bool = false


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if matchstick.burning:
		if lanternburning:
			Global.player.change_lantern_brightness(9.0)
		else: Global.player.change_lantern_brightness(2.5)
	if !matchstick.burning:
		if lanternburning:
			Global.player.change_lantern_brightness(5)
		else: Global.player.change_lantern_brightness(1)


	
	if Input.is_action_just_pressed("lantern") and matchstick.burning:
		start_buring()
	
	match current_stage:
		stages.UNLIT:
			lanternburning = false
			fireanim.play("empty")
			texture = lantern_textutes[0]
		stages.LIT:
			lanternburning = true
			texture = lantern_textutes[1]
		stages.DYING:
			lanternburning = true
		
func start_buring():
	lanternanim.play("lanterngoingdown")
	lanternanim.queue("lanterngoingup")
	await lanternanim.animation_changed
	current_stage = stages.LIT
	
	
	fireanim.play("enterfire")
	await fireanim.animation_finished
	fireanim.play("animatedfire")
	
func _on_burnouttimer_timeout() -> void:
	pass # Replace with function body.
