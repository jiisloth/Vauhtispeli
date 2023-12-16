extends RigidBody2D

signal movement_stop
const BOUNCE_LIMIT = 10
var counter = 0
var speed = 0.04
var catchable = false
var thrown = false
var bounces = 0
var in_box = false
var id = 0
var grounded = false

func _process(delta):
	if linear_velocity.y > 0 and not in_box:
		catchable = true
	if bounces > BOUNCE_LIMIT:
		grounded = true
		linear_velocity.y = 0
	if grounded:
		counter += delta * speed
		$BoxArt.modulate = Color(1, 1 - counter, 1 - counter)
	if counter > 1:
		emit_signal("movement_stop")

func _on_body_entered(body):
	if body.name == "Ground":
		bounces += 1
		if in_box: 
			queue_free()
