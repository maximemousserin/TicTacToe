extends Node

func _ready():
	initSignals()

func initSignals() -> void:
	get_node("btn_jouer").connect("pressed", self, "_on_btn_jouer_pressed")
	get_node("btn_quitter").connect("pressed", self, "_on_btn_quitter_pressed")
	
func _on_btn_jouer_pressed() -> void:
	get_tree().get_current_scene().queue_free()
	get_tree().change_scene("res://scenes/game.tscn")
	
func _on_btn_quitter_pressed() -> void:
	get_tree().quit()