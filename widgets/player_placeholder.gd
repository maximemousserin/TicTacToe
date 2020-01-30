extends Node2D

export var playerName = "PlayerName"

func _ready() -> void:
	get_node("Label").text = playerName
	hideSprite()

func hideSprite() -> void:
	get_node("Sprite").hide()
	
func showSprite() -> void:
	get_node("Sprite").show()