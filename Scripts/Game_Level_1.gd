extends Node2D

func _ready() -> void:
	Music_Controller.play_level1_music()
	add_to_group("blocks")
	


#WORKING ON PAUSE BUTTON
#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#Music_Controller.play_exit_esc_button()
		## Toggle pause
		#get_tree().paused = not get_tree().paused
		## Show or hide pause menu depending on state
		#if get_tree().paused:
			#show()
		#else:
			#hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Music_Controller.play_exit_esc_button()
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
