extends Node2D

var dir = 0
var vdir = 0
var ends = [0,0,0,0]
var coords = Vector2()
var flowing = false
var can_rotate = true
var flowpoint = -1
var max_flow = 1
var flowspeed
var cabletype = -1
var ccolors = [Color("#0000FF"),Color("#ffff00"),Color("#ff0000"),Color("#FFFFFF")]
var flowtime = 0

var pipesize = 60

var tween

signal flowed

enum {
    RIGHT,
    DOWN,
    LEFT,
    UP
}

func _ready():
    var i = 0
    for part in $Parts.get_children():
        part.points[1].x = pipesize/2
        if ends[i]:
            part.show()
        i += 1
    for part in $Flowingparts.get_children():
        part.points[1].x = pipesize/2
    $Base.size = Vector2.ONE*pipesize
    $Base.position = -Vector2.ONE*pipesize/2


func rotate_pipe(d=1):
    dir = (dir + d)%4
    if dir < 0:
        dir = 4 + dir
    vdir += d
    if tween:
        tween.kill()
    var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
    tween.tween_property($Parts, "rotation", -vdir*PI/2,0.2)
    tween.tween_property($Flowingparts, "rotation", -vdir*PI/2,0.2)

        
func kill_out(i):
    $Flowingparts.get_child((dir + i) % 4).default_color.a = 0.8
        


func start_flow(i, t, speed):
    if ends[(dir + i) % 4] and not flowing:
        can_rotate = false
        flowspeed = speed
        cabletype = t
        flowpoint = (dir + i) % 4
        flowing = true
        max_flow = 1/speed
        var flow = $Flowingparts.get_child(flowpoint)
        flow.points[0].x = flow.points[1].x
        var end = 0
        for flowpart in $Flowingparts.get_children():
            flowpart.default_color = ccolors[t]
            if ends[end]:
                flowpart.show()
            if flowpart != flow:
                flowpart.points[1].x = 0
            end += 1
        return true
    return false 


func _process(delta):
    if flowing and flowtime < max_flow:
        flowtime += delta
        if Input.is_action_pressed("pipe_speedup"):
            flowtime += delta *10
        if flowtime >= max_flow:
            flowtime = max_flow
            end_flow()
        var flow = $Flowingparts.get_child(flowpoint)
        if flowtime < max_flow/2:
            flow.points[0].x = flow.points[1].x - 2*(flowtime/max_flow)*flow.points[1].x

        else:
            flow.points[0].x = 0
            var f = 0
            for flowpart in $Flowingparts.get_children():
                if flowpart != flow:
                    flowpart.points[1].x = (2*(flowtime/max_flow)-1)*flow.points[1].x
             

func end_flow():
    var out = ends.duplicate()
    out[flowpoint] = 0
    for r in dir:
        out.push_back(out.pop_front())
    
    emit_signal("flowed", coords, out, cabletype)
    pass # Replace with function body.
