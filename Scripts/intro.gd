extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not $VideoStreamPlayer.is_playing():
		Global.change_scene("easy")
		Global.toggle_menu()

func toggle_menu() -> void:
	Global.change_scene("easy")
	Global.toggle_menu()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Global.change_scene("easy")
		Global.toggle_menu()
		
func reset():
	$VideoStreamPlayer.stop()

func start():
	$VideoStreamPlayer.play()
