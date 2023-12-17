extends Node2D

@export var Pipe : PackedScene
@export var PipeEnd : PackedScene

var score = -1
var potential_score = 3
var gamesize = Vector2(13,13)
@export var PipeSize = 60
@export var FlowSpeed = 0.15

var pipes = {}
var paths = []
var inputs = {}
var outputs = {}
var astar = AStar2D.new()

var ccolors = [Color("#435dd5"),Color("#dabe30"),Color("#cc242e"),Color("#e9e9e9")]

const outdirs = [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]

var flowstarts = [12,26,36,42]
var flowtimers = flowstarts.duplicate()
var flowpoints = [[],[],[],[]]
var flows = [1,1,1,1]
var do_inputs = true
var speed = 1

func _ready():
    make_level()
    check_paths()
    $PipeHolder/Pipecursor.gamesize = Vector2i(gamesize)
    $PipeHolder/Pipecursor.setup_size(PipeSize)
    
    



func make_level():
    while true:
        astar = AStar2D.new()
        if make_paths():
            break
    paths.shuffle()
    for x in gamesize.x:
        for y in gamesize.y:
            var id = y+x*gamesize.y
            var pipe = Pipe.instantiate()
            var ends = [1,1,max(randi()%6-4,0),max(randi()%10-8,0)]
            ends.shuffle()
            for t in len(paths):
                for i in len(paths[t]):
                    if paths[t][i] == id:
                        if i == 0:
                            pipe = PipeEnd.instantiate()
                            pipe.start = true
                            pipe.cabletype = t
                            inputs[t] = Vector2(x,y)
                            flowpoints[t] = [Vector2(x,y)]
                        elif i == len(paths[t])-1:
                            pipe = PipeEnd.instantiate()
                            outputs[t] = Vector2(x,y)
                            pipe.start = false
                            pipe.cabletype = t
                            pipe.finished.connect(pipe_complete.bind(t))
                        else:
                            ends = make_path_pipe(t, i)
                            for r in randi()%3:
                                ends.push_front(ends.pop_back())
            pipe.flowed.connect(pipe_out_flow)
            pipe.ends = ends
            pipe.position = Vector2(x * PipeSize, y * PipeSize)
            pipe.coords = Vector2(x,y)
            pipe.pipesize = PipeSize
            pipes[Vector2(x,y)] = pipe
            $PipeHolder.add_child(pipe)


func make_path_pipe(t, i):
    var ends = [0,0,0,0]
    var pipe = paths[t][i]
    var prevpipe = paths[t][i-1]
    var nextpipe = paths[t][i+1]
    var npipes = [pipe - 1, pipe - gamesize.y, pipe + 1, pipe + gamesize.y]
    for j in 4:
        if prevpipe == npipes[j]:
            ends[j] = 1
        if nextpipe == npipes[j]:
            ends[j] = 1
    for d in len(ends):
        if ends[d] == 0:
            var blocked = false
            for p in len(paths):
                if p > t:
                    for j in paths[p]:
                        if j == npipes[d]:
                            blocked = true
                            break
                if blocked:
                    break
            if not blocked:
                ends[d] = max(randi()%8-6,0)
    return ends


func make_paths():
    for x in gamesize.x:
        for y in gamesize.y:
            astar.add_point(y+x*gamesize.y, Vector2(x,y))
            if y > 0:
                astar.connect_points(y+x*gamesize.y,(y-1)+x*gamesize.y)
            if x > 0:
                astar.connect_points(y+x*gamesize.y,y+(x-1)*gamesize.y)
    for try in 100:           
        make_path()
        if len(paths) == 4:
            return true
    return false

func make_path():
    var start = randi()%int(gamesize.x*gamesize.y)
    var stop = randi()%int(gamesize.x*gamesize.y)
    while astar.is_point_disabled(start) or astar.is_point_disabled(stop):
        start = randi()%int(gamesize.x*gamesize.y)
        stop = randi()%int(gamesize.x*gamesize.y)
    var path = astar.get_id_path(start,stop)
    if len(path) > 2:
        var blocks = []
        for f in 5:
            var block = path[1+randi()%len(path)-3]
            blocks.append(block)
            astar.set_point_disabled(block)
            var ppath = astar.get_id_path(start,stop)
            if len(ppath) == 0:
                break
            path = ppath
            if randf() < (f+1)*0.15:
                break
        for id in path:
            astar.set_point_disabled(id)
        for id in blocks:
            astar.set_point_disabled(id, false)
        paths.append(path)
        astar.set_point_disabled(start)
        astar.set_point_disabled(stop)
        return true
    return false
            
func pipe_complete(t):
    score += 1
    get_parent().set_score(max(0,score), potential_score)
    if score == potential_score:
        get_parent().win_game()
    
        
            
func pipe_out_flow(coords, output, outtype):
    flowpoints[outtype].erase(coords)
    flows[outtype] -= 1
    for i in len(output):
        if output[i]:
            flows[outtype] += 1
            if coords + outdirs[i] in pipes.keys():
                if not pipes[coords + outdirs[i]].start_flow((i+2)%4, outtype, FlowSpeed):
                    pipes[coords].kill_out(i)
                    flows[outtype] -= 1
                else:
                    flowpoints[outtype].append(coords + outdirs[i])
                    var cc = Vector2($PipeHolder/Pipecursor.coords)
                    if cc == coords + outdirs[i]:
                        check_cursor(cc)
            else:
                pipes[coords].kill_out(i)
                flows[outtype] -= 1
    if flows[outtype] == 0:
        potential_score -= 1
        get_parent().set_score(max(0,score), potential_score)
        print(str(outtype) + " stopped flowing")
    check_paths([outtype])
    

    
                
func start_flow(i):
    pipe_out_flow(inputs[i], [1,1,1,1], i)  
                
func _process(delta):
    var i = 0
    for timer in $Timers.get_children():
        if flowtimers[i] > 0:
            flowtimers[i] -= delta * speed
            if Input.is_action_pressed("pipe_speedup"):
                flowtimers[i] -= delta*10
            if flowtimers[i] <= 0:
                flowtimers[i] = 0
                start_flow(i)
            pipes[inputs[i]].set_blink(flowtimers[i], flowstarts[i])
            timer.value = (1-(flowtimers[i] / flowstarts[i]))*100
        i += 1
        


func _on_pipecursor_moved(coords):
    check_cursor(coords)
    
func check_cursor(coords):
    if pipes[Vector2(coords)].can_rotate:
        $PipeHolder/Pipecursor.default_color = Color.LIME_GREEN
    else:
        $PipeHolder/Pipecursor.default_color = Color.DARK_OLIVE_GREEN


func check_paths(types=[0,1,2,3]):
    for pipe in pipes.keys():
        pipes[pipe].reset_highlight(types)
    for t in types:
        var checked = []
        var to_check = {}
        for f in flowpoints[t]:
            to_check[f] = [pipes[f].get_flow_dirs(), 1]
        while to_check:
            var next_check = {}
            for p in to_check.keys():
                checked.append(p)
                next_check.merge(check_pipe(p, to_check[p][0], checked, t, to_check[p][1]))

            to_check = next_check
    for pipe in pipes.keys():
        pipes[pipe].set_highlight()
    var ready_pipes = [false,false,false,false]
    for out in outputs.keys():
        var output = pipes[outputs[out]]
        for i in 4:
            var closest = INF
            var oflows = output.coming_flows
            if oflows[out][i] >= 0:
                for c in len(oflows):
                    if c != out:
                        if oflows[c][i] < closest and oflows[c][i] > -1:
                            closest = oflows[c][i]
                if oflows[out][i] < closest:
                    ready_pipes[out] = true
    var rdy = true
    for p in 4:
        if not ready_pipes[p] and flows[p] > 0:
            rdy = false
    if rdy:
        set_turbospeed()   
                    
func set_turbospeed():
    do_inputs = false
    speed = 100
    for pipe in pipes.keys():
        pipes[pipe].speed = speed
        
        
func check_pipe(coord, ends, checked, t, depth):
    var next = {}
    for i in len(ends):
        if ends[i]:
            if coord + outdirs[i] in pipes.keys() and coord + outdirs[i] not in checked:
                var next_ends = pipes[coord + outdirs[i]].check_flow((i+2)%4, t, depth)
                if next_ends:
                    next[coord + outdirs[i]] = [next_ends, depth+1]
    return next


func _on_pipecursor_rotate_pipe(coords, dir):
    if pipes[Vector2(coords)].can_rotate and do_inputs:
        pipes[Vector2(coords)].rotate_pipe(dir)
    check_paths()
    
    pass # Replace with function body.
