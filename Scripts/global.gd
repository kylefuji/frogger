extends Node

var lives:int = 5
var scores:int = 0
var score:int = 0
var frog_on_player:bool = false
var fly_can_show:bool = false

func level_change() -> void:
	scores = 0
