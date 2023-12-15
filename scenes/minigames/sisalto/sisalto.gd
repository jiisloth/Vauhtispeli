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


func _on_timer_timeout():
	var game = game_prefab.instantiate()
	game.position = Vector2(rng.randf_range(0, 1920), 0)
	$Games.add_child(game)
	$Timer.start(3)
