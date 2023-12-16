extends Node2D


var current_game = null


func set_score(score):
    $IngameUI.set_score(score)
    $GameScore.set_score(score)
    

func set_game(g):
    $IngameUI.show()
    $GameScore.hide()
    if current_game:
        current_game.queue_free()
        current_game = null
        
    current_game = load(Game.games[g]["scene"]).instantiate()
    $GameScore.setup_game(Game.games[g])
    $IngameUI.setup_game(Game.games[g])
    add_child(current_game)
    

func end_game():
    $IngameUI.hide()
    $GameScore.show()
    
