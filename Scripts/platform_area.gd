extends Area2D

@export var speed:float = 100
@export var right_direction:bool = true
@export var initial_position:Vector2 = Vector2.ZERO

signal platform_entered(body:Node2D, platform:Area2D)
signal platform_exited(body:Node2D, platform:Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initial_position == Vector2.ZERO:
		initial_position = position
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _physics_process(delta: float) -> void:
	if right_direction:
		position.x += speed * delta
		if position.x >= 432:
			position = initial_position
	else:
		position.x -= speed * delta
		if position.x <= -64:
			position = initial_position
	
	

func _on_body_entered(body:Node2D):
	platform_entered.emit(body, self)

func _on_body_exited(body:Node2D):
	platform_exited.emit(body, self)
