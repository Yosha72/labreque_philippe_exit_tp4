extends CanvasLayer
 
 
const LEVEL_01 = preload("res://scene/level_01.tscn")
 

 

func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_01)
