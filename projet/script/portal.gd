extends Area2D

var locked: bool = true
@onready var destination: Node2D = $destination
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func try_unlock():
	locked = false
	print("Portail déverrouillé !")
	sprite.play("active")   # animation spéciale quand le portail est activé
	sprite.modulate = Color(0.5, 1.0, 0.5)  # couleur verte pour montrer qu’il est ouvert

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if locked:
			print("Portail verrouillé, entrez le code d'abord !")
		else:
			body.global_position = destination.global_position
			print("Téléportation réussie")
