extends Control

var entered_code: String = ""   # Commence vide
@onready var display: Label = $Label
@onready var tween: Tween = $Tween   # Ajoute un node Tween dans ton Keypad

@export var door_path: NodePath
var door: Node

func _ready():
	door = get_node(door_path)
	display.text = ""   # Nettoyer l'affichage au départ

func press_number(n: int):
	entered_code += str(n)
	display.text = entered_code

func press_ok():
	if door.try_open(entered_code):
		display.text = "OK!"
		flash_color(Color.GREEN)
		sound_success.play()
		hide()
	else:
		display.text = "Erreur"
		entered_code = ""
		flash_color(Color.RED)
		sound_error.play()

@onready var sound_success: AudioStreamPlayer2D = $sound_success
@onready var sound_error: AudioStreamPlayer2D = $sound_error



func press_clear():
	entered_code = ""
	display.text = ""
	flash_color(Color.WHITE)

# --- Boutons numériques ---
func _on_button_0_pressed() -> void: press_number(0)
func _on_button_1_pressed() -> void: press_number(1)
func _on_button_2_pressed() -> void: press_number(2)
func _on_button_3_pressed() -> void: press_number(3)
func _on_button_4_pressed() -> void: press_number(4)
func _on_button_5_pressed() -> void: press_number(5)
func _on_button_6_pressed() -> void: press_number(6)
func _on_button_7_pressed() -> void: press_number(7)
func _on_button_8_pressed() -> void: press_number(8)
func _on_button_9_pressed() -> void: press_number(9)

# --- Bouton "OK" / "Try" ---
func _on_button_try_pressed() -> void:
	press_ok()

# --- Bouton "Clear" ---

func _on_button_clear_pressed() -> void:
	press_clear()

# --- Animation visuelle ---
func flash_color(target_color: Color):
	tween.kill() # stoppe toute animation en cours
	display.modulate = Color.WHITE
	tween.interpolate_property(display, "modulate", display.modulate, target_color, 0.2)
	tween.interpolate_property(display, "modulate", target_color, Color.WHITE, 0.5, delay=0.2)
	tween.start()
