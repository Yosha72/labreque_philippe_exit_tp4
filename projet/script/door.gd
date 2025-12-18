extends Node2D

@export var correct_code: String = "6798"
@export var keypad_scene: PackedScene = preload("res://scene/keypad.tscn")
@export var game_over_scene: PackedScene = preload("res://scene/game_over.tscn")

var is_open: bool = false
var keypad_instance: Control
var current_player: Node2D = null
var failed_attempts: int = 0

func try_open(code: String) -> bool:
	if code == correct_code:
		open_door()
		failed_attempts = 0
		return true
	else:
		failed_attempts += 1
		print("Code incorrect ! Tentative n°", failed_attempts)

		if failed_attempts >= 3:
			game_over()
		return false

func open_door():
	is_open = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("open")
	if keypad_instance:
		hide_keypad()
	
	var portal = get_tree().current_scene.get_node_or_null("portal")
	if portal and portal.has_method("try_unlock"):
		portal.try_unlock()

func game_over():
	print("Game Over !")
	
	# Attendre 1 seconde avant de changer de scène
	await get_tree().create_timer(1.0).timeout
	
	if game_over_scene:
		get_tree().change_scene_to_packed(game_over_scene)


func show_keypad(player: Node2D):
	if not keypad_instance and keypad_scene:
		create_keypad_instance()
	
	if keypad_instance:
		update_keypad_position(player)
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
	keypad_instance.door = self
	
	var ui_layer = get_tree().current_scene.get_node_or_null("UI")
	if ui_layer:
		ui_layer.add_child(keypad_instance)
	else:
		get_tree().current_scene.add_child(keypad_instance)
	
	keypad_instance.hide()

func update_keypad_position(player: Node2D):
	if not keypad_instance:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var center_pos = viewport_size / 2
	
	var diff := player.global_position - global_position
	var offset := Vector2.ZERO
	if diff.y > 0:
		offset = Vector2(0, -100)
	else:
		offset = Vector2(0, 100)
	
	keypad_instance.global_position = center_pos + offset

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or is_open:
		return
	
	current_player = body
	show_keypad(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body == current_player:
		current_player = null
		hide_keypad()
