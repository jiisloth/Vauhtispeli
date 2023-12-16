extends Node2D

var color = Color("#FFFFFF")
var ends = []
var coords = Vector2.ZERO
var start = true
var cabletype = 0
var can_rotate = false

var ccolors = [Color("#0000FF"),Color("#ffff00"),Color("#ff0000"),Color("#FFFFFF")]

var pipesize = 60

signal flowed

func _ready():
    for part in $Parts.get_children():
        part.width = pipesize
        part.default_color = ccolors[cabletype]
    for part in $Inner.get_children():
        part.width = pipesize*0.8
    if start:
        $Inner.queue_free()
    $Base.size = Vector2.ONE*pipesize
    $Base.position = -Vector2.ONE*pipesize/2
        
        
func kill_out(i):
    pass

func start_flow(i, t, speed):
    if not start and t == cabletype:
        $Inner.hide()
        return true
    return false 
