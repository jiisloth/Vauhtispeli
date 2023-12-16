extends Line2D

var gamesize = Vector2i(13,13)
var coords = Vector2i.ZERO
var pipesize = 1

signal moved(coords)
signal rotate_pipe(coords, dir)

func setup_size(ps):
    pipesize = ps
    var p = Vector2(pipesize/2,pipesize/2)
    points[0] = -p
    points[1] = Vector2(p.x, -p.y)
    points[2] = p
    points[3] = Vector2(-p.x, p.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var dir = Vector2i.ZERO
    if Input.is_action_just_pressed("up"):
        dir += Vector2i.UP
    if Input.is_action_just_pressed("down"):
        dir += Vector2i.DOWN
    if Input.is_action_just_pressed("right"):
        dir += Vector2i.RIGHT
    if Input.is_action_just_pressed("left"):
        dir += Vector2i.LEFT
    if dir != Vector2i.ZERO:
        coords += dir
        coords.x = clamp(coords.x, 0, gamesize.x-1)
        coords.y = clamp(coords.y, 0, gamesize.y-1)
        position = coords*pipesize
        emit_signal("moved", coords)
    if Input.is_action_just_pressed("pipe_rotate_left"):
        emit_signal("rotate_pipe", coords, 1)
    if Input.is_action_just_pressed("pipe_rotate_right"):
        emit_signal("rotate_pipe", coords, -1)
    
