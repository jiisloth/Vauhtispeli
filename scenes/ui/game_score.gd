extends CanvasLayer


var gameinfo = null


func setup_game(ginfo):
    $VBoxContainer/Gamename.text = ginfo["display_name"]
    gameinfo = ginfo
    
    
func set_score(score):
    var stars = $VBoxContainer/Stars.get_children()
    var i = 0
    for star in stars:
        if score > i:
            star.modulate = gameinfo["color"]
        else:
            star.modulate = Color("#000000")
        i += 1
            
    
