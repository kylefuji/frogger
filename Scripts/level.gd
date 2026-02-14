extends Node2D

func _ready() -> void:
	Global.toggle_pause()
	#process_mode = Node.PROCESS_MODE_ALWAYS

func toggle_menu():
	if $Game.visible == false:
		$Game.visible = true
		$Menu.visible = false
	else:
		$Game.visible = false
		$Menu.visible = true
