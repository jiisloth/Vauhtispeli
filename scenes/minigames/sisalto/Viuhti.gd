extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var game_held = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	if game_held:
		if Input.is_action_just_pressed("ui_accept"):
			release_game()

func pick_up_game(game_box):
	$GameCollisionArea.set_deferred("monitoring",false)
	$HeldGame.texture = game_box.get_node("BoxArt").texture
	$HeldGame.visible = true
	game_held = true
	
func release_game():
	$GameCollisionArea.monitoring = true
	$HeldGame.visible = false
	var new_game = get_parent().spawn_new_game($GameCollisionArea.global_position - Vector2(0, 100))
	new_game.linear_velocity = Vector2(velocity.x, velocity.y - 1000)
	game_held = false

func _on_game_collision_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("game_box"):
		var game_box = area.get_parent()
		game_box.queue_free()
		pick_up_game(game_box)

