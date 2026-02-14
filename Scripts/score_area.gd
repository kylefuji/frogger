extends Area2D

signal score()
signal extra_score()
signal fly_spawn_timer()

var is_scored:bool = false
var is_fly_area:bool = false
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$FlyTimer.timeout.connect(_on_fly_timeout)
	
func _process(delta: float) -> void:
	if not is_scored and Global.fly_can_show:
		if rng.randf() >= 0.999:
			spawn_fly()

func _on_body_entered(body:Node2D):
	$EndFrog.visible = true
	Global.scores += 1
	is_scored = true
	if is_fly_area:
		_on_fly_timeout()
		extra_score.emit()
	else:
		score.emit()
	set_deferred("monitoring", false)

func reset() -> void:
	$EndFrog.visible = false
	set_deferred("monitoring", true)
	is_scored = false

func spawn_fly() -> void:
	if not is_scored and Global.fly_can_show:
		Global.fly_can_show = false
		$Fly.visible = true
		is_fly_area = true
		$FlyTimer.start()
	
func _on_fly_timeout():
	$Fly.visible = false
	is_fly_area = false
	fly_spawn_timer.emit()
	$FlyTimer.stop()
