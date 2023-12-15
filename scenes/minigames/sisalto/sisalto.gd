extends Node2D

@export var game_prefab : PackedScene

var rng = RandomNumberGenerator.new()
enum {STAR_1, STAR_2, STAR_3}
var phase = STAR_1

var time_when_next_spawn = 4

func _ready():
	pass

func _process(delta):
	
	if phase == STAR_1:
		pass
	elif phase == STAR_2:
		pass
	elif phase == STAR_3:
		pass

func spawn_new_game(position):
	var game = game_prefab.instantiate()
	game.position = position
	game.movement_stop.connect(level_failed)
	$Games.add_child(game)
	return game

func _on_timer_timeout():
	spawn_new_game(Vector2(rng.randf_range(0, 1920), 0))
	$Timer.start(3)
	
func level_failed():
	# print("rippistä")
	pass
