extends CharacterBody2D

@export var speed := 300
@onready var step_sound: AudioStreamPlayer2D = $step_sound

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	# Détection du "press" (pas du maintien)
	if Input.is_action_just_pressed("left") \
	or Input.is_action_just_pressed("right") \
	or Input.is_action_just_pressed("up") \
	or Input.is_action_just_pressed("down"):
		step_sound.play()

func _physics_process(_delta):
	get_input()
	move_and_slide()
