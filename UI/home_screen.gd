extends Control

const MAIN_SCENE = preload("uid://dhaqv27gocslu")


func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)


func _on_exit_button_button_down() -> void:
	get_tree().quit()
