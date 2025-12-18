extends Control

var entered_code: String = ""
var max_code_length: int = 4  # Limite le nombre de chiffres

@onready var display: Label = $Label
@onready var sound_success: AudioStreamPlayer2D = $sound_sucess
@onready var sound_error: AudioStreamPlayer2D = $sound_error

var door: Node

func _ready():
	display.text = ""
	# Afficher des underscores pour indiquer le nombre de chiffres attendus
	display.text = "_ _ _ _"

func press_number(n: int):
	# Limiter la longueur du code
	if entered_code.length() >= max_code_length:
		return
	
	entered_code += str(n)
	update_display()

func update_display():
	# Afficher le code avec des underscores pour les chiffres manquants
	var display_text := ""
	for i in range(max_code_length):
		if i < entered_code.length():
			display_text += entered_code[i] + " "
		else:
			display_text += "_ "
	display.text = display_text.strip_edges()

func press_ok():
	if entered_code.length() == 0:
		return
	
	if door and door.has_method("try_open") and door.try_open(entered_code):
		display.text = "✓ OUVERT"
		flash_color(Color.GREEN)
		if sound_success:
			sound_success.play()
		
		# Cacher après un court délai
		await get_tree().create_timer(1.0).timeout
		hide()
	else:
		display.text = "✗ ERREUR"
		flash_color(Color.RED)
		if sound_error:
			sound_error.play()
		
		# Réinitialiser après un court délai
		await get_tree().create_timer(1.0).timeout
		press_clear()

func press_clear():
	entered_code = ""
	update_display()
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

func _on_button_try_pressed() -> void: press_ok()
func _on_button_clear_pressed() -> void: press_clear()

# --- Animation visuelle ---
func flash_color(target_color: Color):
	var t := create_tween()
	t.tween_property(display, "modulate", target_color, 0.2)
	t.tween_interval(0.2)
	t.tween_property(display, "modulate", Color.WHITE, 0.5)

func flash_button(button: Button):
	var t := create_tween()
	t.tween_property(button, "modulate", Color.YELLOW, 0.1)
	t.tween_property(button, "modulate", Color.WHITE, 0.2)

# Support du clavier physique (optionnel)
func _input(event):
	if not visible:
		return
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_0, KEY_KP_0: press_number(0)
			KEY_1, KEY_KP_1: press_number(1)
			KEY_2, KEY_KP_2: press_number(2)
			KEY_3, KEY_KP_3: press_number(3)
			KEY_4, KEY_KP_4: press_number(4)
			KEY_5, KEY_KP_5: press_number(5)
			KEY_6, KEY_KP_6: press_number(6)
			KEY_7, KEY_KP_7: press_number(7)
			KEY_8, KEY_KP_8: press_number(8)
			KEY_9, KEY_KP_9: press_number(9)
			KEY_ENTER, KEY_KP_ENTER: press_ok()
			KEY_BACKSPACE, KEY_DELETE: press_clear()
			KEY_ESCAPE: hide()
