extends RigidBody2D

signal movement_stop
const BOUNCE_LIMIT = 10
var counter = 0
var speed = 0.2
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
		var new_color = Color(1, 1 - counter, 1 - counter)
		$BoxArt.modulate = new_color
		$ColorRect.modulate = new_color
	if counter > 1:
		emit_signal("movement_stop")
		queue_free()

func _on_body_entered(body):
	if body.name == "Ground":
		bounces += 1
		if in_box: 
			queue_free()

func go_to_box():
	in_box = true
	catchable = false
	$BoxArt.z_index = -3
	$ColorRect.z_index = -3
	linear_velocity.x = 0
