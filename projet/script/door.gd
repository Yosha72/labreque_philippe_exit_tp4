extends Node2D

@export var correct_code: String = "7224"
@export var keypad_scene: PackedScene
var is_open: bool = false
var keypad_instance: Control

func try_open(code: String) -> bool:
	if code == correct_code:
		open_door()
		return true
	return false

func open_door():
	is_open = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("open")
	if keypad_instance:
		keypad_instance.hide()

	# Déverrouiller le portail nommé "portal"
	var portal1 = get_tree().current_scene.get_node("portal")
	if portal1 and portal1.has_method("try_unlock"):
		portal1.try_unlock()

# Dans Door.gd
var ui_layer = get_tree().current_scene.get_node("UI") # ton CanvasLayer
CanvasLayer.add_child(keypad_instance)



func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Zone détectée par la porte")
	if body.is_in_group("player"):
		print("Le joueur est bien détecté")
	if not keypad_instance and keypad_scene:
		keypad_instance = keypad_scene.instantiate()
		get_tree().current_scene.add_child(keypad_instance)
		keypad_instance.door = self

			# --- Positionnement dynamique selon la position du joueur ---
		var offset := Vector2(0, 96)  # par défaut en bas
		var player_pos := body.global_position
		var door_pos := global_position

		if player_pos.x < door_pos.x:
			offset = Vector2(-96, 0)   # joueur à gauche → keypad à gauche
		elif player_pos.x > door_pos.x:
			offset = Vector2(96, 0)    # joueur à droite → keypad à droite
		elif player_pos.y < door_pos.y:
			offset = Vector2(0, -96)   # joueur au-dessus → keypad au-dessus
		else:
			offset = Vector2(0, 96)    # joueur en dessous → keypad en dessous

		keypad_instance.global_position = door_pos + offset
# --- Effet fade-in ---
		keypad_instance.modulate.a = 0.0  # invisible au départ
		var tween := create_tween()
		tween.tween_property(keypad_instance, "modulate:a", 1.0, 0.5) # fade-in en 0.5s

	if keypad_instance:
		keypad_instance.show()
