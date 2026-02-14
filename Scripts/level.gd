extends Node2D

func toggle_menu():
	if $Game.visible == false:
		$Game.visible = true
		$Menu.visible = false
		get_tree().paused = false
		Global.is_paused = false
	else:
		$Game.visible = false
		$Menu.show_menu()
		get_tree().paused = true
		Global.is_paused = true


func _on_menu_play_press() -> void:
	toggle_menu()


func _on_menu_restart_press() -> void:
	pass # Replace with function body.
