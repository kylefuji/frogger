extends Area2D

@export var speed:float = 100
@export var right_direction:bool = true
@export var initial_position:Vector2 = Vector2.ZERO

var frog_showing:bool = false
var frog_can_show:bool = false
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

signal platform_entered(body:Node2D, platform:Area2D)
signal platform_exited(body:Node2D, platform:Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BlueFrog.hide_frog()
	$Timer.start()
	if initial_position == Vector2.ZERO:
		initial_position = position
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _physics_process(delta: float) -> void:
	if right_direction:
		position.x += speed * delta
		if position.x >= 432:
			position = initial_position
			handle_frog()
	else:
		position.x -= speed * delta
		if position.x <= -64:
			position = initial_position
			handle_frog()
		

func handle_frog():
	if frog_showing:
		frog_can_show = false
		$Timer.start()
		frog_showing = false
		$BlueFrog.hide_frog()
	elif frog_can_show and rng.randf() >= 0.33 and not Global.frog_on_player:
		$BlueFrog.show_frog()
		frog_showing = true

func _on_body_entered(body:Node2D):
	platform_entered.emit(body, self)

func _on_body_exited(body:Node2D):
	platform_exited.emit(body, self)


func _on_timer_timeout() -> void:
	frog_can_show = true
	$Timer.stop()
