extends Node2D

signal play_press()
signal restart_press()
var sound_on_icon = preload("res://PNGs/sound_on_icon.png")
var sound_off_icon = preload("res://PNGs/sound_off_icon.png")
var sound_on:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$HighScore.text = "High Score: %d" % Global.high_score 
	var master_bus_idx = AudioServer.get_bus_index("Master")
	sound_on = not AudioServer.is_bus_mute(master_bus_idx)
	if not sound_on:
		$SoundButton.icon = sound_off_icon
	

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


func _on_sound_button_pressed() -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")
	if sound_on:
		$SoundButton.icon = sound_off_icon
		sound_on = false
		AudioServer.set_bus_mute(master_bus_idx, true)
	else:
		$SoundButton.icon = sound_on_icon
		sound_on = true
		AudioServer.set_bus_mute(master_bus_idx, false)
