extends Node2D

func toggle_menu():
	if $Game.visible == false:
		hide_menu()
	else:
		show_menu()

func hide_menu():
	$Game.visible = true
	$Menu.visible = false
	get_tree().paused = false
	Global.is_paused = false
func show_menu():
	$Game.visible = false
	$Menu.show_menu()
	get_tree().paused = true
	Global.is_paused = true
		
func reset():
	hide_menu()
	$Game.reset()


func _on_menu_play_press() -> void:
	toggle_menu()


func _on_menu_restart_press() -> void:
	Global.reset()


func _on_menu_button_pressed() -> void:
	toggle_menu()
