extends Area2D

@export var speed:float = 100
@export var right_direction:bool = true
@export var initial_position:Vector2 = Vector2.ZERO

func _ready() -> void:
	if initial_position == Vector2.ZERO:
		initial_position = position


func _physics_process(delta: float) -> void:
	if right_direction:
		position.x += speed * delta
		if position.x >= 432:
			position = initial_position
	else:
		position.x -= speed * delta
		if position.x <= -64:
			position = initial_position
