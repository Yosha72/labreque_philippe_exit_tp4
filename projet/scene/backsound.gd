extends Node

@onready var ambiance: AudioStreamPlayer = $ambiance

func _ready():
	ambiance.stream.loop = true  # active la boucle
	ambiance.play()
