extends Area2D

signal score()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	$EndFrog.visible = true
	Global.scores += 1
	score.emit()
