extends Node2D

signal play_press()
signal restart_press()
var sound_on_icon = preload("res://PNGs/sound_on_icon.png")
var sound_off_icon = preload("res://PNGs/sound_off_icon.png")
var sound_on:bool
var http:HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	http = $HTTPRequestGetter
	http.request_completed.connect(_on_http_request_completed)
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
	get_high_score()
	
func get_high_score() -> void:
	var query_params = "gamekey=%s&format=json&limit=1" % Global.purple_token_api_key
	
	var base64_string:= Marshalls.utf8_to_base64(query_params)
	var signature = base64_string + Global.purple_token_secret
	signature = signature.sha256_text()
	
	var fetch_url = "https://purpletoken.com/update/v3/get?payload=%s&sig=%s" % [base64_string, signature]
	
	http.request(fetch_url)

func _on_http_request_completed(result:int, code:int, headers:PackedStringArray, body:PackedByteArray):
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var data = json.data
		if data.count > 0 and data.scores[0].score > Global.high_score:
			Global.high_score = data.scores[0].score
	

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
