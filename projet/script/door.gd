extends Node2D

@export var correct_code: String = "7224"
@export var keypad_scene: PackedScene

var is_open: bool = false
var keypad_instance: Control
var current_player: Node2D = null

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
		hide_keypad()
	
	# Déverrouiller le portail nommé "portal"
	var portal1 = get_tree().current_scene.get_node_or_null("portal")
	if portal1 and portal1.has_method("try_unlock"):
		portal1.try_unlock()

func show_keypad(player: Node2D):
	if not keypad_instance and keypad_scene:
		create_keypad_instance()
	
	if keypad_instance:
		# Repositionner selon la position actuelle du joueur
		update_keypad_position(player)
		
		# Afficher avec fade-in
		keypad_instance.modulate.a = 0.0
		keypad_instance.show()
		var tween := create_tween()
		tween.tween_property(keypad_instance, "modulate:a", 1.0, 0.3)

func hide_keypad():
	if keypad_instance and keypad_instance.visible:
		var tween := create_tween()
		tween.tween_property(keypad_instance, "modulate:a", 0.0, 0.3)
		tween.tween_callback(keypad_instance.hide)

func create_keypad_instance():
	keypad_instance = keypad_scene.instantiate()
	keypad_instance.door = self  # ← Ligne au bon endroit !
	
	# Ajouter au UI layer si disponible, sinon à la scène courante
	var ui_layer = get_tree().current_scene.get_node_or_null("UI")
	if ui_layer:
		ui_layer.add_child(keypad_instance)
	else:
		get_tree().current_scene.add_child(keypad_instance)
	
	keypad_instance.hide()

func update_keypad_position(player: Node2D):
	if not keypad_instance:
		return
	
	var offset := Vector2(0, 96)
	var player_pos := player.global_position
	var door_pos := global_position
	
	# Déterminer la position optimale
	var diff := player_pos - door_pos
	
	if abs(diff.x) > abs(diff.y):
		# Le joueur est plus sur le côté
		offset = Vector2(96 if diff.x > 0 else -96, 0)
	else:
		# Le joueur est plus en haut/bas
		offset = Vector2(0, 96 if diff.y > 0 else -96)
	
	keypad_instance.global_position = door_pos + offset

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	if is_open:
		return  # Ne pas afficher le keypad si la porte est déjà ouverte
	
	print("Le joueur s'approche de la porte")
	current_player = body
	show_keypad(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body == current_player:
		print("Le joueur s'éloigne de la porte")
		current_player = null
		hide_keypad()
