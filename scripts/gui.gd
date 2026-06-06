extends Control

@onready var player = get_parent().get_parent()
@onready var map = player.get_parent()
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var topleft = {
	"hp": $topleft/hp,
	"stamina": $topleft/stamina
}
@onready var topright = {
	"bells": $topright/bells_collected
}
@onready var bottomleft = {
	"matchstick": $bottomleft/matchstickgui
}

func _process(_delta: float) -> void:
	topleft.hp.value = player.hp
	topleft.stamina.value = player.stamina
	topright.bells.text = str(map.bells_collected) + "/" + str(map.number_of_bells) + " bells rung"
