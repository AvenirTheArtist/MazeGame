extends Control

@onready var player = get_parent().get_parent()
@onready var map = player.get_parent()
@onready var animplayer: AnimationPlayer = $matchstickanims
@onready var topleft = {
	"hp": $topleft/hp,
	"stamina": $bottommiddle/stamina
}
@onready var topright = {
	"bells": $topright/bells_collected
}
@onready var bottomleft = {
	"matchstick": $bottomleft/matchstickgui,
	"matches_in_reserve": $bottomleft/matches_in_reserve
}

func _ready() -> void:
	change_matches_count(2)

func _process(_delta: float) -> void:
	topleft.hp.value = player.hp
	topleft.stamina.value = player.stamina
	topright.bells.text = str(map.bells_collected) + "/" + str(map.number_of_bells) + " bells rung"
	

func change_matches_count(number: int) -> void:
	var node = bottomleft.matches_in_reserve
	for i in node.get_children():
		i.queue_free()
	for i in number - 1:
		var match_png = preload("res://player_stuff/match_hud_icon.tscn").instantiate()
		#match_png.scale *= 0.1
		node.add_child(match_png)
	
