extends CharacterBody2D

@export var speed := 100
@onready var step_sound: AudioStreamPlayer2D = $step_sound
var last_direction := Vector2(1,0)
var near_door: Area2D = null

func _ready() -> void:
	$AnimatedSprite2D.play("down_idle")

func _physics_process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()

	# Jouer le son de pas en continu si on bouge
	if direction.length() > 0:
		if not step_sound.playing:
			step_sound.play()
		last_direction = direction
		play_walk_animation(direction)
	else:
		if step_sound.playing:
			step_sound.stop()
		play_idle_animation(last_direction)

func play_walk_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("player_right")
		else:
			$AnimatedSprite2D.play("player_left")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("player_down")
		else:
			$AnimatedSprite2D.play("player_up")

func play_idle_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("right_idle")
		else:
			$AnimatedSprite2D.play("left_idle")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("down_idle")
		else:
			$AnimatedSprite
			
