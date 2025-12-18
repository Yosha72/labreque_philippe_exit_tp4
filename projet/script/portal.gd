extends Area2D

@export var keypad_scene: PackedScene
var keypad_instance: Control
var current_player: Node2D = null

var locked: bool = true
var teleport_cooldown: bool = false

@onready var destination: Node2D = $destination
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	if locked:
		sprite.modulate = Color.RED
		if sprite.sprite_frames.has_animation("locked"):
			sprite.play("locked")

func try_unlock():
	if locked:
		locked = false
		print("Portail déverrouillé !")
		sprite.modulate = Color.GREEN
		if sprite.sprite_frames.has_animation("active"):
			sprite.play("active")
			
func try_open(code: String) -> bool:
	# Ici tu définis le code correct pour déverrouiller le portail
	var correct_code = "68"
	
	if code == correct_code:
		try_unlock()
		if keypad_instance:
			keypad_instance.hide()
		return true
	else:
		print("Code incorrect pour le portail")
		return false


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	current_player = body
	
	if locked:
		show_keypad(body)   # 👉 Affiche le Keypad quand le joueur entre dans le portail verrouillé
	else:
		if not teleport_cooldown:
			teleport_player(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body == current_player:
		current_player = null
		hide_keypad()

func show_keypad(_player: Node2D):
	if not keypad_instance and keypad_scene:
		keypad_instance = keypad_scene.instantiate()
		keypad_instance.door = self   # ⚠️ Ici tu peux adapter : soit la porte, soit le portail
		var ui_layer = get_tree().current_scene.get_node_or_null("UI")
		if ui_layer:
			ui_layer.add_child(keypad_instance)
		else:
			get_tree().current_scene.add_child(keypad_instance)
	keypad_instance.show()

func hide_keypad():
	if keypad_instance:
		keypad_instance.hide()

func teleport_player(body: Node2D):
	teleport_cooldown = true
	print("Téléportation en cours...")
	body.global_position = destination.global_position
	print("Téléportation réussie")
	await get_tree().create_timer(0.5).timeout
	teleport_cooldown = false
