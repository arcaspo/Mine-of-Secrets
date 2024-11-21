extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var terrain: Node2D = %terrain
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _process(delta: float) -> void:
	# Mouse in viewport coordinates.
	if Input.is_action_just_pressed("click"):
		animated_sprite.play("mine")
		var rot = position.angle_to_point(get_global_mouse_position())
		terrain.mine(position, 60, 100, -rot+1.571)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	#flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction <0:
		animated_sprite.flip_h = true
	
	#play animation
	if is_on_floor():
		if direction == 0:
			if !animated_sprite.is_playing():
				print("idle")
				animated_sprite.play("idle")
		else:
			if !animated_sprite.is_playing():
				animated_sprite.play("walk")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
