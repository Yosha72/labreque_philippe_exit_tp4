extends AudioStreamPlayer

@onready var ambiance: AudioStreamPlayer = $ambiance

func _ready():
	ambiance.stream.loop = true  # Assure la boucle
	ambiance.play()
