extends CanvasLayer


var gameinfo = null


func setup_game(ginfo):
    $VBoxContainer/Gamename.text = ginfo["display_name"]
    gameinfo = ginfo
