extends CanvasLayer


var gameinfo = null


func setup_game(ginfo):
    $VBoxContainer/Gamename.text = ginfo["display_name"]
    gameinfo = ginfo
    set_score()
    
    
func set_score(score=0, potential_score=3):
    var stars = $VBoxContainer/Stars.get_children()
    var i = 0
    for star in stars:
        if score > i:
            star.modulate = gameinfo["color"]
        else:
            star.modulate = Color("#000000")
        i += 1
    match potential_score:
        3:
            $VBoxContainer/Stars/Star.show()
            $VBoxContainer/Stars/Star2.show()
            $VBoxContainer/Stars/Star3.show()
        2:
            $VBoxContainer/Stars/Star.show()
            $VBoxContainer/Stars/Star2.hide()
            $VBoxContainer/Stars/Star3.show()
        1:
            $VBoxContainer/Stars/Star.hide()
            $VBoxContainer/Stars/Star2.show()
            $VBoxContainer/Stars/Star3.hide()
        0:
            $VBoxContainer/Stars/Star.hide()
            $VBoxContainer/Stars/Star2.hide()
            $VBoxContainer/Stars/Star3.hide()
            
            
    
