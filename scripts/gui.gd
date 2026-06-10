extends Control

@onready var player = get_parent().get_parent()
@onready var map = player.get_parent()
@onready var animplayer: AnimationPlayer = $matchstickanims
@onready var bottommiddle = {
	"stamina": $bottommiddle/stamina
}
@onready var topright = {
	"bells": $topright/bells_collected
}
@onready var topleft = {
	"matches_in_reserve" = $topleft/matches_in_reserve
}
@onready var bottomleft = {
	"matchstick": $bottomleft/matchstickgui,
}
@onready var shader = $CanvasLayer/ColorRect
var shader_settings = []

func _ready() -> void:
	change_matches_count(2)

func _process(_delta: float) -> void:
	change_matches_count(player.matchstick_amount)
	player.ghost
	bottommiddle.stamina.value = player.stamina
	topright.bells.text = str(map.bells_collected) + "/" + str(map.number_of_bells) + " bells rung"
	

func change_matches_count(number: int) -> void:
	
	var node = topleft.matches_in_reserve
	for i in node.get_children():
		i.queue_free()
	for i in number - 1:
		var match_png = preload("res://player_stuff/match_hud_icon.tscn").instantiate()
		#match_png.scale *= 0.1
		node.add_child(match_png)
	
