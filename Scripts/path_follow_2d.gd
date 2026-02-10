extends PathFollow2D

@export var speed = 0.2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += delta * speed
	if has_node("PlatformArea"):
		var platformArea = get_node("PlatformArea")
		if platformArea.has_node("Turtle"):
			var turtle = platformArea.get_node("Turtle")
			if turtle.animation == "dive" and turtle.frame == 5:
				platformArea.get_node("CollisionShape2D").disabled = true
			else:
				platformArea.get_node("CollisionShape2D").disabled = false
