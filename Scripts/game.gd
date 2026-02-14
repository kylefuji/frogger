extends Node2D

var duration:int = 0
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_lives()
	_update_score()
	$FlySpawnTimer.start()
	$LevelTimer.timeout.connect(_on_level_timeout)
	$FlySpawnTimer.timeout.connect(_on_fly_spawn_timeout)
	set_timer(30)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset() -> void:
	Global.scores = 0
	for i in 5:
		$ScoreZones.get_node("ScoreArea" + str(i+1)).reset()
		
func _update_score() -> void:
	$ScoreText.text = str(Global.score)

func _update_lives() -> void:
	if Global.lives < 0:
		$Frog.paused = true
		$"GameOverText".visible = true
		stop_timer()
		
	elif Global.lives < 5:
		for missing in range(5, Global.lives, -1):
			$Lives.get_node("FrogLife%d" % missing).visible = false
			
func stop_timer() -> void:
	$LevelTimer.stop()
		

func set_timer(duration_arg:int) -> void:
	duration = duration_arg
	$TimeText.text = str(duration)
	$LevelTimer.start()
	
func _on_level_timeout() -> void:
	duration -= 1
	if duration >= 10:
		$LevelTimer.start()
		$TimeText.text = str(duration)
		$TimeText.add_theme_color_override("default_color", Color(1, 1, 1))
		$TimeTextLabel.add_theme_color_override("default_color", Color(1, 1, 1))
	elif duration < 10 and duration >= 0:
		$LevelTimer.start()
		$TimeText.text = str(duration)
		$TimeText.add_theme_color_override("default_color", Color(1, 0, 0))
		$TimeTextLabel.add_theme_color_override("default_color", Color(1, 0, 0))
	else:
		$LevelTimer.stop()
		$Frog.death()
		$TimeText.add_theme_color_override("default_color", Color(1, 1, 1))
		$TimeTextLabel.add_theme_color_override("default_color", Color(1, 1, 1))
	

func _on_fly_spawn_timer() -> void:
	$FlySpawnTimer.wait_time = rng.randi_range(5, 20)
	$FlySpawnTimer.start()
	
func _on_fly_spawn_timeout() -> void:
	Global.fly_can_show = true
	$FlySpawnTimer.stop()
