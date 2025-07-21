extends Node2D

func _ready() -> void:
	Music_Controller.play_level5_music()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Music_Controller.play_exit_esc_button()
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
