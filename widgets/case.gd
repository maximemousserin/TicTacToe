extends Button

const Globals = preload("res://scripts/globals.gd")
const Players = Globals.Players

export var label = "case"

var player = null
var img_o = preload("res://assets/images/o.png")
var img_x = preload("res://assets/images/x.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.icon = null
	pass # Replace with function body.

func reset() -> void:
	player = null
	self.icon = null

func setX() -> void:
	self.icon = img_x
	
func setO() -> void:
	self.icon = img_o

func setPlayer(p) -> void:
	if player == null:
		player = p
		if player == Players.X:
			setX()
		else:
			setO()