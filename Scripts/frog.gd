extends CharacterBody2D

var moving:bool = false
var target_direction:Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var move_distance = 16
var speed:float = 100

func _process(delta: float) -> void:
	if moving:
		move(delta)
	elif Input.is_action_pressed("move up"):
		target_direction = Vector2.UP
		$AnimatedSprite2D.play("walk")
		move(delta)
	elif Input.is_action_pressed("move left"):
		target_direction = Vector2.LEFT
		$AnimatedSprite2D.play("walk")
		move(delta)
	elif Input.is_action_pressed("move right"):
		target_direction = Vector2.RIGHT
		$AnimatedSprite2D.play("walk")
		move(delta)
	elif Input.is_action_pressed("move down"):
		target_direction = Vector2.DOWN
		$AnimatedSprite2D.play("walk")
		move(delta)
	else:
		target_direction = Vector2.ZERO
		$AnimatedSprite2D.stop()
		

func move(delta: float) -> void:
	if not moving and target_direction != Vector2.ZERO:
		target_position = target_direction * move_distance + position
		look_at(target_position)
		moving = true
	
	elif moving:
		var distance = global_position.distance_to(target_position)
		
		var max_speed_this_frame = distance / delta
		var current_speed = min(speed, max_speed_this_frame)

		velocity = target_direction * current_speed

		move_and_slide()
		
		if distance < 1.0: # Use a small threshold
			position = target_position
			moving = false
			velocity = Vector2.ZERO
