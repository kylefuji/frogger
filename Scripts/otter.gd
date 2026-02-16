extends Area2D

@export var speed:float = 100
@export var right_direction:bool = true
@export var initial_position:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initial_position == Vector2.ZERO:
		initial_position = position
	area_entered.connect(_on_area_entered)
	
func _physics_process(delta: float) -> void:
	if right_direction:
		position.x += speed * delta
		if position.x >= 432:
			position = initial_position
	else:
		position.x -= speed * delta
		if position.x <= -64:
			position = initial_position
	
func _on_area_entered(area:Area2D):
	if area.name != "Snake2":
		position = initial_position
