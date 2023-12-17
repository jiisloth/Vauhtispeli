extends Node2D


var current_game = null



func set_score(score, potential_score=3):
	if potential_score <= 0:
		$GameOver.show()
	$IngameUI.set_score(score, potential_score)
	$GameScore.set_score(score, potential_score)
	

func set_game(g):
	$IngameUI.show()
	$GameScore.hide()
	if current_game:
		current_game.queue_free()
		current_game = null
		
	current_game = load(Game.games[g]["scene"]).instantiate()
	$GameScore.setup_game(Game.games[g])
	$GameOver.setup_game(Game.games[g])
	$IngameUI.setup_game(Game.games[g])
	add_child(current_game)
	

func end_game():
	current_game.process_mode = PROCESS_MODE_DISABLED
	$IngameUI.hide_score()
	$GameScore.show()
	
