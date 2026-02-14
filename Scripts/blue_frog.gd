extends Area2D

@export var move_distance = 16
@export var speed:float = 100
var target_direction:Vector2 = Vector2.RIGHT
var target_position:Vector2 = Vector2.ZERO
var initial_position: Vector2 = Vector2.ZERO
var moving:bool = false
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

signal blue_frog_entered(body: Node2D, blue_frog: Area2D)

func _ready() -> void:
	initial_position = position
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not moving:
		if rng.randf() >= 0.98:
			if position.x >= 32:
				target_direction = Vector2.LEFT
			if position.x <= -16:
				target_direction = Vector2.RIGHT
			$AnimatedSprite2D.play()
			move(delta)
	else:
		move(delta)

func move(delta:float) -> void:
	if not moving:
		moving = true
		target_position = target_direction * move_distance + position
		look_at(global_position + target_direction)
	else:
		var distance = position.distance_to(target_position)
		if target_direction == Vector2.LEFT:
			position.x -= speed * delta
		elif target_direction == Vector2.RIGHT:
			position.x += speed * delta
		
		if distance <= 1.0:
			position = target_position
			target_position = Vector2.ZERO
			moving = false
			$AnimatedSprite2D.stop()
	
func _on_body_entered(body:Node2D):
	blue_frog_entered.emit(body, self)

func hide_frog() -> void:
	visible = false
	set_deferred("monitoring", false)
	

func show_frog() -> void:
	visible = true
	set_deferred("monitoring", true)
