extends Node2D

@export var safety = 100
const screen_width = 1920
var entity = null

func _ready():
	entity = get_parent()

func _process(delta):
	if entity.position.x < -safety:
		entity.position.x = screen_width + safety
	if entity.position.x > screen_width + safety:
		entity.position.x = -safety
