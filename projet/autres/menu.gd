extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_01.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/setting_menu.tscn")


func _on_escape_pressed() -> void:
	get_tree().quit()
