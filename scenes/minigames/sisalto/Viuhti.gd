extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -2.5 * 600.0
const throw_force = 2000
const DRIFT_SPEED = 30
const STOP_SPEED = 15
const START_SPEED = 50
const THROW_SPEED = 100
const THROW_MAXSPEED = 600
const THROW_VELOCITY_COEFFICIENT = 0.2
var throw_direction = 0
var throw_velocity = 0

var game_held = false
var heldgame

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 4 * ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if is_on_floor():
			$AnimationPlayer.play("viuhti_side_walk")
		var speed = DRIFT_SPEED if sign(direction) != sign(velocity.x) else START_SPEED
		velocity.x = move_toward(velocity.x, direction * SPEED, speed)
		throw_direction = move_toward(throw_direction, direction * THROW_MAXSPEED, THROW_SPEED)
	else:
		if is_on_floor():
			$AnimationPlayer.play("viuhti_side_stop")
		velocity.x = move_toward(velocity.x, 0, STOP_SPEED)
		throw_direction = move_toward(throw_direction, 0, 50)
	
	if Input.is_action_pressed("ui_up"):
		throw_velocity = 0 #move_toward(
#			throw_velocity, 0, THROW_SPEED)
	else:
		throw_velocity = throw_direction + velocity.x * THROW_VELOCITY_COEFFICIENT
	
	$AnimationPlayer.speed_scale = 1 + abs(velocity.x)/SPEED * 2
	
	if direction < 0:
		$SpriteBody.scale.x = -1
		$SpriteArms.scale.x = -1
		$GameHolder.scale.x = -1
		
	elif direction > 0:
		$SpriteBody.scale.x = 1
		$SpriteArms.scale.x = 1
		$GameHolder.scale.x = 1
	
	if !is_on_floor():
		$AnimationPlayer.play("viuhti_side_jump")
	
	move_and_slide()

func _draw():
	draw_line(Vector2.ZERO, Vector2(throw_direction  + velocity.x * THROW_VELOCITY_COEFFICIENT, 0), Color(1, 0, 0), 5, true)

func _process(delta):
	if game_held:
		if Input.is_action_just_pressed("shoot"):
			release_game()
	# queue_redraw()

func pick_up_game(game_box):
	$GameCollisionArea.set_deferred("monitoring",false)
	$GameHolder/HeldGame/BoxArt.frame = game_box.get_node("BoxArt").frame
	$GameHolder/HeldGame/ColorRect.color = game_box.get_node("ColorRect").color
	$GameHolder/HeldGame.visible = true
	game_held = true
	
func release_game():
	$GameCollisionArea.monitoring = true
	
	$GameHolder/HeldGame.visible = false
	var new_game = get_parent().spawn_new_game(
		$GameCollisionArea.global_position,
		$GameHolder/HeldGame/BoxArt.frame	
	)
	new_game.thrown = true
	new_game.linear_velocity = Vector2(
		throw_velocity, -throw_force
	)
	game_held = false

func _on_game_collision_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var game_box = area.get_parent()
	if game_box.is_in_group("game_box") and game_box.catchable:
		game_box.queue_free()
		pick_up_game(game_box)

