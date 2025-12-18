extends Control

var entered_code: String = ""
@onready var display: Label = $Label
@onready var sound_success: AudioStreamPlayer2D = $sound_success
@onready var sound_error: AudioStreamPlayer2D = $sound_error

var door: Node

func _ready():
	display.text = ""

func press_number(n: int):
	entered_code += str(n)
	display.text = entered_code

func press_ok():
	if door and door.has_method("try_open") and door.try_open(entered_code):
		display.text = "OK!"
		flash_color(Color.GREEN)
		sound_success.play()
		hide()
	else:
		display.text = "Erreur"
		entered_code = ""
		flash_color(Color.RED)
		sound_error.play()

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
