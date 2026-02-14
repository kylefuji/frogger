extends Node

var lives:int = 5
var scores:int = 0
var score:int = 0
var high_score:int = 0
var frog_on_player:bool = false
var fly_can_show:bool = false
var is_paused:bool = false
var start_up:bool = true
const easyLevelScene = preload("res://Scenes/EasyLevel.tscn")
const mediumLevelScene = preload("res://Scenes/MediumLevel.tscn")
var easyLevel:Node2D = null
var mediumLevel:Node2D = null
var root

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	easyLevel = easyLevelScene.instantiate()
	mediumLevel = mediumLevelScene.instantiate()
	root = get_tree().root

func _process(_delta: float) -> void:
	if score > high_score:
		high_score = score

func level_change() -> void:
	scores = 0

func toggle_pause() -> void:
	is_paused = not is_paused
	get_tree().paused = not get_tree().paused 
	
func change_scene(scene:String):
	var current_scene = get_tree().current_scene
	if scene == "easy":
		root.add_child(easyLevel)
		get_tree().current_scene = easyLevel
	elif scene == "medium":
		root.add_child(mediumLevel)
		get_tree().current_scene = mediumLevel
	current_scene.queue_free()

func next_scene():
	var current_scene = get_tree().current_scene
	if current_scene == easyLevel:
		change_scene("medium")
	
func toggle_menu() -> void:
	toggle_pause()
	get_tree().current_scene.toggle_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not start_up:
		toggle_menu()
