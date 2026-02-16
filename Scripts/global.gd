extends Node

var lives:int = 5
var scores:int = 0
var score:int = 0
var high_score:int = 0
var frog_on_player:bool = false
var fly_can_show:bool = false
var is_paused:bool = false
var start_up:bool = false
const easy_level_scene = preload("res://Scenes/EasyLevel.tscn")
const medium_level_scene = preload("res://Scenes/MediumLevel.tscn")
const hard_level_scene = preload("res://Scenes/HardLevel.tscn")
const very_hard_level_scene = preload("res://Scenes/VeryHardLevel.tscn")
const end_level_scene = preload("res://Scenes/EndLevel.tscn")
var easy_level:Node2D = null
var medium_level:Node2D = null
var hard_level:Node2D = null
var very_hard_level:Node2D = null
var end_level:Node2D = null
var root = null
var purple_token_api_key:String = ""
var purple_token_secret:String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	root = get_tree().root
	#var score = load_from_file()
	#if score:
		#high_score = int(score)

func _process(_delta: float) -> void:
	if score > high_score:
		high_score = score
		#save_to_file(str(high_score))

func level_change() -> void:
	scores = 0

func toggle_pause() -> void:
	is_paused = not is_paused
	get_tree().paused = not get_tree().paused 
	
func change_scene(scene:String):
	var current_scene = get_tree().current_scene
	if scene == "easy":
		easy_level = easy_level_scene.instantiate()
		root.add_child(easy_level)
		get_tree().current_scene = easy_level
	elif scene == "medium":
		medium_level = medium_level_scene.instantiate()
		root.add_child(medium_level)
		get_tree().current_scene = medium_level
	elif scene == "hard":
		hard_level = hard_level_scene.instantiate()
		root.add_child(hard_level)
		get_tree().current_scene = hard_level
	elif scene == "very_hard":
		very_hard_level = very_hard_level_scene.instantiate()
		root.add_child(very_hard_level)
		get_tree().current_scene = very_hard_level
	elif scene == "end":
		end_level = end_level_scene.instantiate()
		root.add_child(end_level)
		get_tree().current_scene = end_level
	current_scene.reset()
	current_scene.queue_free()

func next_scene():
	var current_scene = get_tree().current_scene
	if current_scene == easy_level:
		change_scene("medium")
	elif current_scene == medium_level:
		change_scene("hard")
	elif current_scene == hard_level:
		change_scene("very_hard")
	elif current_scene == very_hard_level:
		change_scene("end")
		
func reset():
	lives = 5
	scores = 0
	score = 0
	get_tree().current_scene.reset()
	if get_tree().current_scene != easy_level:
		change_scene("easy")
	
func toggle_menu() -> void:
	get_tree().current_scene.toggle_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") and not start_up:
		toggle_menu()

func save_to_file(content):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(content)

func load_from_file():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		return content
	return null
