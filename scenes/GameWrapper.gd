extends Node2D


var current_game = null



func set_score(score, potential_score=3):
	if potential_score <= 0:
		game_over()
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
	
func game_over():
	$GameOver.show()
	end_game()
	
func win_game():
	$GameScore.show()
	end_game()

func end_game():
	current_game.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	$IngameUI.hide_score()
	
