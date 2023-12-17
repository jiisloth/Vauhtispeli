extends CanvasLayer


var gameinfo = null


func setup_game(ginfo):
    $Stars.show()   
    gameinfo = ginfo
    set_score()
    
func hide_score():
    $Stars.hide()   
    
func set_score(score=0,potential_score=3):          
    var stars = $Stars.get_children()
    var i = 0
    for star in stars:
        var sprite = star.get_node("Control/Star")
        if score > i:
            star.modulate = gameinfo["color"]
        else:
            star.modulate = gameinfo["color"]
            star.modulate.s = 0.3
            star.modulate.v = 0.8
        if potential_score > i:
            sprite.position = Vector2.ZERO
            sprite.rotation = 0
        elif sprite.position == Vector2.ZERO:
            var tween = create_tween()
            tween.tween_property(sprite, "rotation", PI/6, 0.2)
            tween.tween_property(sprite, "position", Vector2(2,10), 0.2)
            tween.chain().set_ease(Tween.EASE_IN)
            tween.tween_property(sprite, "position", Vector2(100,3000), 1.5)
            tween.parallel()
            tween.tween_property(sprite, "rotation", PI, 1.5)
        i += 1
        
