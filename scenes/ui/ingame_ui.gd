extends CanvasLayer


var gameinfo = null


func setup_game(ginfo):
    gameinfo = ginfo
    
    
func set_score(score):
    var stars = $Stars.get_children()
    var i = 0
    for star in stars:
        if score > i:
            star.modulate = gameinfo["color"]
        else:
            star.modulate = Color("#000000")
