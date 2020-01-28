extends Node2D

export var label = "case"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(label)
	pass # Replace with function body.


func _on_StaticBody2D_mouse_entered():
	print(label)
	pass # Replace with function body.


func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	print(event)
	pass # Replace with function body.
