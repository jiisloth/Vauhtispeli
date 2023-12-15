extends Node


enum {
    TEKNIIKKA,
    SISALTO,
    KOODI,
    TILAT,
    ENDGAME,
    HUOLTO
}


var games = {
    TEKNIIKKA: {
        "scene": "res://scenes/minigames/tekniikka.tscn",
        "display_name": "Tekniikka",
        "color": Color("#fcad03")
        },
    SISALTO: {
        "scene": "res://scenes/minigames/sisalto.tscn",
        "display_name": "Sisältö",
        "color": Color("#fcad03")
        },
    KOODI: {
        "scene": "res://scenes/minigames/koodi.tscn",
        "display_name": "Koodi",
        "color": Color("#fcad03")
        }
}
