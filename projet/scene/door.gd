extends Node2D

@export var correct_code: String = "7224"
var is_open: bool = false

func try_open(code: String) -> bool:
	if code == correct_code:
		open_door()
		return true
	return false

func open_door():
	is_open = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("open")


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "player":
		print("Le joueur est entré dans la zone")
		get_node("/root/level_01/UI/Keypad").show()


func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
