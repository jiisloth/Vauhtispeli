extends Node2D

var color = Color("#FFFFFF")
var ends = []
var coords = Vector2.ZERO
var start = true
var cabletype = 0
var can_rotate = false
var speed = 1
var ccolors = [Color("#435dd5"),Color("#dabe30"),Color("#cc242e"),Color("#e9e9e9")]

var pipesize = 60

signal flowed
signal finished

var coming_flows = [-1,-1,-1,-1]

func _ready():
    $Parts.get_child(cabletype).show()
    if not start:
        $Parts.get_child(cabletype).modulate.v = 0.3
        
    $Base.size = Vector2.ONE*pipesize
    $Base.position = -Vector2.ONE*pipesize/2

func set_blink(dt, t):
    if dt == 0:
        $Parts.get_child(cabletype).modulate.v = 1
    else:
        var a = 1/(dt+5)+1
        $Parts.get_child(cabletype).modulate.v = 0.8 - sin(100*pow(a,5)+1)*0.2
    
func get_flow_dirs():
    return [1,1,1,1]


func reset_highlight(t):
    for i in t:
        coming_flows[i] = [-1,-1,-1,-1]
    pass
    
func set_highlight():
    pass


func check_flow(i,t,d):
    if not start:
        coming_flows[t][i] = d
    
         
func kill_out(i):
    pass

func start_flow(i, t, speed):
    if not start and t == cabletype:
        emit_signal("finished")
        $Parts.get_child(cabletype).modulate = Color.WHITE
        
        return true
    return false 
