extends CanvasLayer


var gameinfo = null


func setup_game(ginfo):
    $VBoxContainer/Gamename.text = ginfo["display_name"]
    gameinfo = ginfo
    set_score()
    
    
func set_score(score=0, potential_score=3):
    var stars = $VBoxContainer/Stars.get_children()
    for star in stars:
        star.modulate = gameinfo["color"]
        star.show()
    match potential_score:
        3:
            match score:
                2:  
                    dim_star(stars[2])
                1:
                    dim_star(stars[2])
                    dim_star(stars[1])
        2:
            stars[1].hide()
            match score:
                1:
                    dim_star(stars[2])
            
        1:
            stars[0].hide()
            stars[2].hide()
        0:
            stars[0].hide()
            stars[1].hide()
            stars[2].hide()


func dim_star(star):
    star.modulate.v = 0.2
    star.modulate.s = 0.3
            
    
