extends Node2D

@export var Pipe : PackedScene
@export var PipeEnd : PackedScene

var score = 3
var gamesize = Vector2(13,13)
@export var PipeSize = 60
@export var FlowSpeed = 0.08

var pipes = {}
var paths = []
var starts = {}
var astar = AStar2D.new()

var ccolors = [Color("#0000FF"),Color("#ffff00"),Color("#ff0000"),Color("#FFFFFF")]

const outdirs = [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]

var flowstarts = [10,20,40,80]
var flows = [1,1,1,1]

func _ready():
    seed(1)
    get_parent().set_score(score)
    
    
    
    var i = 0
    for timer in $Timers.get_children():
        timer.get_node("Timer").start(flowstarts[i])
        timer.get_node("Timer").timeout.connect(start_flow.bind(i))
        i += 1
    make_level()
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
                            starts[t] = Vector2(x,y)
                        elif i == len(paths[t])-1:
                            pipe = PipeEnd.instantiate()
                            pipe.start = false
                            pipe.cabletype = t
                        else:
                            ends = make_path_pipe(t, i)
                            for r in randi()%3:
                                ends.push_front(ends.pop_back())
            pipe.ends = ends
            pipe.position = Vector2(x * PipeSize, y * PipeSize)
            pipe.coords = Vector2(x,y)
            pipe.pipesize = PipeSize
            pipes[Vector2(x,y)] = pipe
            pipe.flowed.connect(pipe_out_flow)
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
        return true
    return false
            

        
            
func pipe_out_flow(coords, output, outtype):
    flows[outtype] -= 1
    for i in len(output):
        if output[i]:
            flows[outtype] += 1
            if coords + outdirs[i] in pipes.keys():
                if not pipes[coords + outdirs[i]].start_flow((i+2)%4, outtype, FlowSpeed):
                    pipes[coords].kill_out(i)
                    flows[outtype] -= 1
                else:
                    var cc = Vector2($PipeHolder/Pipecursor.coords)
                    if cc == coords + outdirs[i]:
                        check_cursor(cc)
            else:
                pipes[coords].kill_out(i)
                flows[outtype] -= 1
    if flows[outtype] == 0:
        print(str(outtype) + " stopped flowing")

    
                
func start_flow(i):
    pipe_out_flow(starts[i], [1,1,1,1], i)  
                
func _process(delta):
    var i = 0
    for timer in $Timers.get_children():
        timer.value = (1- (timer.get_node("Timer").time_left / flowstarts[i]))*100
        i += 1


func _on_pipecursor_moved(coords):
    check_cursor(coords)
    
func check_cursor(coords):
    if pipes[Vector2(coords)].can_rotate:
        $PipeHolder/Pipecursor.default_color = Color.WHITE
    else:
        $PipeHolder/Pipecursor.default_color = Color.DIM_GRAY


func _on_pipecursor_rotate_pipe(coords, dir):
    if pipes[Vector2(coords)].can_rotate:
        pipes[Vector2(coords)].rotate_pipe(dir)
    
    pass # Replace with function body.
