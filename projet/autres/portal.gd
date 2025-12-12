extends Area2D


#target element
@export var target_portal : Node2D


func _on_body_entered(body):
	if target_portal == null:
		return

	if  "player" in body.name:
	
		body.position = target_portal.position
		
