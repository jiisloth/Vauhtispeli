extends Node2D

var score = 2


func _ready():
    get_parent().set_score(score)
