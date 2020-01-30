extends Node

func _ready() -> void:
	get_node("btn_rejouer").connect("pressed", self, "_on_btn_rejouer_pressed")

func _on_btn_rejouer_pressed() -> void:
	queue_free()
	get_tree().change_scene("res://scenes/game.tscn")