extends Node2D

@export var my_games = [0]


var games_collected = 0

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var game_box = area.get_parent()
	if game_box.is_in_group("game_box") and game_box.catchable and game_box.thrown:
		if my_games.has(game_box.id):
			games_collected += 1
			game_box.get_parent().get_parent().add_collected()
		game_box.go_to_box()
