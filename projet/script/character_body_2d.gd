extends CharacterBody2D

@export var speed := 300
@onready var step_sound: AudioStreamPlayer2D = $step_sound
var near_door: Area2D = null

func _ready() -> void:
	$"./AnimatedSprite2D".play("down_idle")
	



func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if Input.is_action_just_pressed("left") \
	or Input.is_action_just_pressed("right") \
	or Input.is_action_just_pressed("up") \
	or Input.is_action_just_pressed("down"):
		step_sound.play()

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") and near_door != null:
		near_door.get_node("Keypad").show()

	get_input()
	move_and_slide()

func _on_Door_area_entered(area: Area2D) -> void:
	near_door = area

func _on_Door_area_exited(area: Area2D) -> void:
	if near_door == area:
		near_door = null
