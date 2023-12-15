extends Node2D


var current_game = null


func set_game(g):
    $IngameUI.show()
    $GameScore.hide()
    if current_game:
        current_game.queue_free()
        current_game = null
        
    var current_game = load(Game.games[g]["scene"]).instantiate()
    add_child(current_game)
    
func end_game():
    $IngameUI.hide()
    $GameScore.show()
    
