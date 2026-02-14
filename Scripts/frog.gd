extends CharacterBody2D

signal updateScore()
signal updateLives()

@export var move_distance = 16
@export var speed:float = 100
var moving:bool = false
var paused:bool = false
var playing_dying_animation:bool = false
var safe_zone:bool = false
var death_zone:bool = false
var target_direction:Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var initial_position: Vector2 = Vector2.ZERO
var start_move_position: Vector2 = Vector2.ZERO
var start_drag_position: Vector2 = Vector2.ZERO
var current_platform:Area2D = null
var last_platform_pos = null
var row_count:int = 0

func _ready() -> void:
	initial_position = position
	row_count = initial_position.y / 16

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not playing_dying_animation and not moving and not paused:
		if event.is_pressed():
			start_drag_position = event.position
		else:
			var distance:Vector2 = event.position - start_drag_position
			if abs(distance.x) >= abs(distance.y):
				if distance.x > 0: 
					target_direction = Vector2.RIGHT
				elif distance.x < 0:
					target_direction = Vector2.LEFT
			else:
				if distance.y > 0:
					target_direction = Vector2.DOWN
				elif distance.y < 0:
					target_direction = Vector2.UP
			$AnimatedSprite2D.play("walk")
			move(0)

func _physics_process(delta: float) -> void:
	if paused:
		return
	if death_zone and not safe_zone and not moving:
		death()
	elif moving:
		move(delta)
	elif playing_dying_animation:
		pass
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
		target_position = Vector2.ZERO
		$AnimatedSprite2D.stop()
		move(delta)

func move(delta: float) -> void:
	if not moving and target_direction != Vector2.ZERO:
		start_move_position = position
		target_position = target_direction * move_distance + position
		look_at(target_position)
		moving = true
		$MoveSound.play()
	
	elif moving:
		var distance = global_position.distance_to(target_position)
		
		var max_speed_this_frame = distance / delta
		var current_speed = min(speed, max_speed_this_frame)
		
		if current_platform:
			var delta_pos = current_platform.global_position - last_platform_pos
			target_position += delta_pos
			velocity = target_direction * current_speed + delta_pos/delta
			last_platform_pos = current_platform.global_position
		else:
			velocity = target_direction * current_speed
		
		move_and_slide()
		
		if distance < 1.0: 
			target_direction = Vector2.ZERO
			target_position = Vector2.ZERO
			moving = false
			velocity = Vector2.ZERO
			if position.y / 16 < row_count:
				row_count = position.y / 16
				Global.score += 10
				updateScore.emit()
			
		if is_on_wall():
			moving = false
			target_direction = Vector2.ZERO
			target_position = Vector2.ZERO
			velocity = Vector2.ZERO
			
	elif current_platform:
		var delta_pos = current_platform.global_position - last_platform_pos
		velocity = delta_pos/delta
		move_and_slide()
		last_platform_pos = current_platform.global_position
			
func death() -> void:
	if not $DeathSound.playing and not playing_dying_animation:
		Global.lives -= 1
		updateLives.emit()
		$DeathSound.play()
	get_parent().stop_timer()
	$FrogBlue.visible = false
	Global.frog_on_player = false
	playing_dying_animation = true
	moving = false
	current_platform = null
	target_position = Vector2.UP * move_distance + position
	look_at(target_position)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	if Global.lives > 0:
		get_parent().set_timer(30)
	playing_dying_animation = false
	position = initial_position
	row_count = initial_position.y / 16
	death_zone = false
	safe_zone = false
	


func _on_kill_area_body_entered(body: Node2D) -> void:
	if body == self:
		death_zone = true

func _on_kill_area_body_exited(body: Node2D) -> void:
	if body == self:
		death_zone = false

func _on_platform_area_body_entered(body: Node2D, nodePath: NodePath) -> void:
	if body == self and not playing_dying_animation:
		current_platform = get_node(nodePath)
		last_platform_pos = current_platform.global_position
		safe_zone = true

func _on_platform_area_body_exited(body: Node2D, nodePath: NodePath) -> void:
	if body == self and current_platform == get_node(nodePath):
		current_platform = null
		safe_zone = false


func _on_platform_area_platform_entered(body: Node2D, platform: Area2D) -> void:
	if body == self and not playing_dying_animation:
		current_platform = platform
		last_platform_pos = current_platform.global_position
		safe_zone = true


func _on_platform_area_platform_exited(body: Node2D, platform: Area2D) -> void:
	if body == self and current_platform == platform:
		current_platform = null
		safe_zone = false


func _on_score_area_score() -> void:
	get_parent().stop_timer()
	$FrogBlue.visible = false
	if Global.frog_on_player:
		Global.score += 200
		$ExtraScoreSound.play()
	else:
		$ScoreSound.play()
	Global.frog_on_player = false
	Global.score += 200
	Global.score += get_parent().duration * 20
	#print(Global.scores)
	updateScore.emit()
	position = initial_position
	row_count = initial_position.y / 16
	current_platform = null
	paused = true
	moving = false
	death_zone = false
	safe_zone = false
	$RespawnTimer.start(1)


func _on_timer_timeout() -> void:
	if Global.scores == 5:
		get_parent().reset()
		Global.score += 1000
	paused = false
	get_parent().set_timer(30)
	$RespawnTimer.stop()


func _on_blue_frog_entered(body: Node2D, blue_frog: Area2D) -> void:
	if body == self:
		$FrogBlue.visible = true
		$FrogPickUpSound.play()
		blue_frog.hide_frog()
		Global.frog_on_player = true


func _on_score_area_extra_score() -> void:
	Global.score += 200
	get_parent().stop_timer()
	$ExtraScoreSound.play()
	$FrogBlue.visible = false
	if Global.frog_on_player:
		Global.score += 200
	Global.frog_on_player = false
	Global.score += 200
	Global.score += get_parent().duration * 20
	#print(Global.scores)
	updateScore.emit()
	position = initial_position
	row_count = initial_position.y / 16
	current_platform = null
	paused = true
	moving = false
	death_zone = false
	safe_zone = false
	$RespawnTimer.start(1)
