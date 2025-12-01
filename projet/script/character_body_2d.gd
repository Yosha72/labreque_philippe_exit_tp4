extends CharacterBody2D

@export var speed := 300

@onready var step_sound: AudioStreamPlayer2D = $step_sound

var step_timer := 0.0
var step_interval := 0.5  # durée entre les sons (ajuste comme tu veux)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()

	# Si le joueur bouge
	if velocity.length() > 0.1:
		step_timer -= delta
		if step_timer <= 0.0:
			step_sound.play()
			step_timer = step_interval
	else:
		# reset quand il s'arrête pour garder la cohérence
		step_timer = 0.0

	move_and_slide()
