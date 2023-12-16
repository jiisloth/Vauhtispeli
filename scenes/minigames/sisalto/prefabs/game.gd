extends RigidBody2D

signal movement_stop

var counter = 0
var speed = 0.04

var id = 0

func _process(delta):
	if abs(linear_velocity.y) < 0.1:
		counter += delta * speed
		$BoxArt.modulate = Color(1, 1 - counter, 1 - counter)
	if counter > 1:
		emit_signal("movement_stop")
