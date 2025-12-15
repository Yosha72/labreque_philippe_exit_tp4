extends CharacterBody2D

var max_speed = 100
var last_direction := Vector2(1,0)



@export var speed := 100
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
	
	var direction = Input.get_vector("left","right","up","down" )
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
	
func play_walk_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("right_idle")
	elif direction.x < 0:
		$AnimatedSprite2D.play("left_idle")
		
	if direction.y > 0:
		$AnimatedSprite2D.play("down_idle")
	elif direction.y < 0:
		$AnimatedSprite2D.play("up_idle")
	

func _on_Door_area_entered(area: Area2D) -> void:
	near_door = area

func _on_Door_area_exited(area: Area2D) -> void:
	if near_door == area:
		near_door = null
