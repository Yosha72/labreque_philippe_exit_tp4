extends Control

var entered_code: String = "7224"
@onready var display: Label = $Label

@export var door_path: NodePath
var door: Node

func _ready():
	door = get_node(door_path)

func press_number(n: int):
	entered_code += str(n)
	display.text = entered_code

func press_ok():
	if door.try_open(entered_code):
		display.text = "OK!"
		hide()
	else:
		display.text = "Erreur"
		entered_code = ""




func _on_button_0_pressed() -> void:
	pass # Replace with function body.


func _on_button_1_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	pass # Replace with function body.


func _on_button_5_pressed() -> void:
	pass # Replace with function body.


func _on_button_6_pressed() -> void:
	pass # Replace with function body.


func _on_button_7_pressed() -> void:
	pass # Replace with function body.


func _on_button_8_pressed() -> void:
	pass # Replace with function body.


func _on_button_9_pressed() -> void:
	pass # Replace with function body.


func _on_button_try_pressed() -> void:
	pass # Replace with function body.
	
