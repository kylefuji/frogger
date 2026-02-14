extends Node2D

signal play_press()
signal restart_press()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$HighScore.text = "High Score: %d" % Global.high_score 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HighScore.text = "High Score: %d" % Global.high_score 

func show_menu() -> void:
	visible = true
	$PlayButton.grab_focus()


func _on_play_button_pressed() -> void:
	play_press.emit()


func _on_restart_button_pressed() -> void:
	restart_press.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
