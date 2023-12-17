extends Node2D

@export var my_games = [0]

var correct_games_collected = 0
var wrong_games_collected = 0
var wrong_game_limit = 3.0
var sisalto

func _ready():
	sisalto = get_parent().get_parent()

func set_container_color():
	var col = 1 - wrong_games_collected / wrong_game_limit
	var box_color = Color(1, col, col)
	$BoxForeground.modulate = box_color
	$BoxBackground.modulate = box_color

func destroy_container():
	$CollisionShape2D.disabled = true
	sisalto.remove_container()

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var game_box = area.get_parent()
	if game_box.is_in_group("game_box") and game_box.catchable and game_box.thrown:
		if game_box.id in my_games:
			correct_games_collected += 1
			sisalto.add_collected()
		else:
			wrong_games_collected += 1
			set_container_color()
		if wrong_games_collected == wrong_game_limit:
			destroy_container()
		game_box.go_to_box()
