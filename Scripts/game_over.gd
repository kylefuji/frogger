extends Node2D

var http_getter:HTTPRequest
var http_sender:HTTPRequest

func _ready() -> void:
	http_getter = $HTTPRequestGetter
	http_sender = $HTTPRequestSender
	http_getter.request_completed.connect(_on_http_request_getter_completed)
	http_sender.request_completed.connect(_on_http_request_sender_completed)

func game_over() -> void:
	visible = true
	$Panel/ScoreText.text = "Score: %d" % Global.score
	var query_params = "gamekey=%s&format=json&limit=3" % Global.purple_token_api_key
	
	var base64_string:= Marshalls.utf8_to_base64(query_params)
	var signature = base64_string + Global.purple_token_secret
	signature = signature.sha256_text()
	
	var fetch_url = "https://purpletoken.com/update/v3/get?payload=%s&sig=%s" % [base64_string, signature]
	
	http_getter.request(fetch_url)

func reset() -> void:
	visible = false
	$Panel/SubmitButton.visible = true
	$Panel/SubmittedButton.visible = false
	
func _on_http_request_getter_completed(result:int, code:int, headers:PackedStringArray, body:PackedByteArray):
	var json = JSON.new()
	var high_score_text:String = ""
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var data = json.data
		for score in data.scores:
			high_score_text += "%s: %d\n" % [score.player, score.score]
	$Panel/HighScores.text = high_score_text


func _on_submit_button_pressed() -> void:
	if $Panel/NameInput.text == "":
		return
	
	var query_params = "gamekey=%s&player=%s&score=%d" % [Global.purple_token_api_key, $Panel/NameInput.text, Global.score]
	
	var base64_string:= Marshalls.utf8_to_base64(query_params)
	var signature = base64_string + Global.purple_token_secret
	signature = signature.sha256_text()
	
	http_sender.request("https://purpletoken.com/update/v3/submit?payload=%s&sig=%s" % [base64_string, signature])
	
func _on_http_request_sender_completed(result:int, code:int, headers:PackedStringArray, body:PackedByteArray):
	if result == 0:
		$Panel/SubmitButton.hide()
		$Panel/SubmittedButton.show()
		game_over()
	
