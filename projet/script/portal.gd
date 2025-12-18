extends Area2D

var locked: bool = true
var teleport_cooldown: bool = false

@onready var destination: Node2D = $destination
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# État visuel initial
	if locked:
		sprite.play("locked")
		sprite.modulate = Color.RED

func try_unlock():
	if locked:
		locked = false
		print("Portail déverrouillé !")
		sprite.play("active")
		sprite.modulate = Color.GREEN

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not locked and not teleport_cooldown:
		teleport_player(body)
	elif body.is_in_group("player") and locked:
		print("Portail verrouillé, entrez le code d'abord !")

func teleport_player(body: Node2D):
	teleport_cooldown = true
	print("Téléportation en cours...")
	body.global_position = destination.global_position
	print("Téléportation réussie")
	await get_tree().create_timer(0.5).timeout
	teleport_cooldown = false
