extends Node2D

@export var game_prefab : PackedScene
@export var game_container_prefab : PackedScene

var phase_limits = [3,  7, 10, 15, 20,  30]
var phase_delays = [5,  4,  4.5,  3, 2.5,  1.5]

@export var container_games = [
	[0],
	[1],
	[2],
	[3]
]
@export var container_colors = [
	Color(0,0,0),
	Color(0,0,0),
	Color(0,0,0),
	Color(0,0,0)
]

var rng = RandomNumberGenerator.new()
const phases = 6
var phase = 0
var score = 0
var potential_score = 3

var score_phase = 0
var collected_boxes_score_limits = [10, 20, 30]

var collected_boxes_win_limit = 30
var collected_boxes = 0
var spawned_boxes = 0
var active_containers = 4
var game_wrapper

func _ready():
	game_wrapper = get_parent()
	for i in 4:
		var game_cont = game_container_prefab.instantiate()
		game_cont.position = Vector2(i * 500, 0)
		$GameContainers.add_child(game_cont)
		game_cont.get_node("Label").frame = i
		game_cont.my_games = container_games[i]
		game_cont.get_node("BoxBackground").modulate = container_colors[i]
		game_cont.get_node("BoxForeground").modulate = container_colors[i]
	game_wrapper.set_score(score)

func _process(delta):
	if spawned_boxes == phase_limits[phase]:
		if phase == phases - 1:
			pass
		else:
			phase += 1

func spawn_new_game(position, id):
	var game = game_prefab.instantiate()
	game.position = position
	var sprite = game.get_node("ColorRect/BoxArt")
	if id == null:
		id = rng.randi_range(0, sprite.hframes - 1)
	sprite.frame = id
	game.id = id
	game.get_node("ColorRect").color = container_colors[id]
	game.movement_stop.connect(decrease_score)
	$Games.add_child(game)
	spawned_boxes += 1
	return game

func _on_timer_timeout():
	spawn_new_game(
		Vector2(rng.randf_range(0, 1920), 0),
		null
	)
	$Timer.start(phase_delays[phase])
	
func decrease_score():
	potential_score -= 1
	game_wrapper.set_score(score, potential_score)

func add_score():
	score += 1
	game_wrapper.set_score(score, potential_score)

func remove_container():
	active_containers -= 1
	if active_containers == 0:
		game_wrapper.game_over()

func add_collected():
	collected_boxes += 1
	$RichTextLabel.text = "Collected: " + str(collected_boxes) + "/" + str(collected_boxes_win_limit)
	# if $Timer.time_left > 2:
	#	$Timer.emit_signal("timeout")

	if collected_boxes == collected_boxes_score_limits[score_phase]:
		score_phase += 1
		add_score()
	if collected_boxes == collected_boxes_win_limit:
		game_wrapper.win_game()
