extends Area2D

var locked: bool = true
var teleport_cooldown: bool = false

@onready var destination: Node2D = $destination
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Animation par défaut pour un portail verrouillé
	if locked:
		sprite.play("locked")  # ou "default" selon tes animations
		sprite.modulate = Color(1.0, 0.3, 0.3)  # rouge pour verrouillé

func try_unlock():
	if locked:
		locked = false
		print("Portail déverrouillé !")
		sprite.play("active")
		
		# Effet de transition de couleur
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(0.5, 1.0, 0.5), 0.5)
		
		# Effet visuel supplémentaire (optionnel)
		tween.set_parallel(true)
		tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.3)
		tween.set_parallel(false)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.2)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	if locked:
		print("Portail verrouillé, entrez le code d'abord !")
		# Effet visuel de rejet
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(1.5, 0.3, 0.3), 0.1)
		tween.tween_property(sprite, "modulate", Color(1.0, 0.3, 0.3), 0.1)
		return
	
	# Éviter la téléportation en boucle
	if teleport_cooldown:
		return
	
	teleport_cooldown = true
	
	# Effet de téléportation
	print("Téléportation en cours...")
	
	# Fade out du joueur (optionnel)
	if body.has_node("Sprite2D") or body.has_node("AnimatedSprite2D"):
		var player_sprite = body.get_node_or_null("Sprite2D")
		if not player_sprite:
			player_sprite = body.get_node_or_null("AnimatedSprite2D")
		
		if player_sprite:
			var tween = create_tween()
			tween.tween_property(player_sprite, "modulate:a", 0.0, 0.3)
			await tween.finished
	
	# Téléportation
	body.global_position = destination.global_position
	print("Téléportation réussie")
	
	# Fade in du joueur (optionnel)
	if body.has_node("Sprite2D") or body.has_node("AnimatedSprite2D"):
		var player_sprite = body.get_node_or_null("Sprite2D")
		if not player_sprite:
			player_sprite = body.get_node_or_null("AnimatedSprite2D")
		
		if player_sprite:
			var tween = create_tween()
			tween.tween_property(player_sprite, "modulate:a", 1.0, 0.3)
	
	# Réinitialiser le cooldown après un délai
	await get_tree().create_timer(1.0).timeout
	teleport_cooldown = false

func _on_body_exited(body: Node2D) -> void:
	# Réinitialiser le cooldown si le joueur sort sans se téléporter
	if body.is_in_group("player"):
		teleport_cooldown = false
