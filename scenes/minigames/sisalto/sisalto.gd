extends Node2D

@export var game_prefab : PackedScene
var phase_limits = [3,  7, 10, 15, 20,  30]
var phase_delays = [5,  4,  4.5,  3, 2.5,  1.8]


var rng = RandomNumberGenerator.new()
const phases = 6
var phase = 0
var score = 3

var collected_boxes_win_limit = 30
var collected_boxes = 0
var spawned_boxes = 0
var active_containers = 4

func _ready():
	get_parent().set_score(score)

func _process(delta):
	
	if spawned_boxes == phase_limits[phase]:
		if phase == phases - 1:
			pass
		else:
			phase += 1
	if collected_boxes == collected_boxes_win_limit:
		get_parent().end_game()

func spawn_new_game(position, id):
	var game = game_prefab.instantiate()
	game.position = position
	var sprite = game.get_node("BoxArt")
	if id == null:
		id = rng.randi_range(0, sprite.hframes - 1)
	sprite.frame = id
	game.id = id
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
	score -= 1
	get_parent().set_score(score)
	if score == 0:
		get_parent().end_game()

func remove_container():
	active_containers -= 1
	if active_containers == 0:
		get_parent().end_game()

func add_collected():
	collected_boxes += 1
	$RichTextLabel.text = "Collected: " + str(collected_boxes)
