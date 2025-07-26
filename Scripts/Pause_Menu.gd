extends Control

func _ready():
	call_deferred("_check_if_should_exist")

func _check_if_should_exist():
	var current_scene = get_tree().current_scene
	if current_scene == null or not current_scene.name.begins_with("Game_Level"):
		queue_free()
		return

	visible = false
	set_process_unhandled_input(true)
	_connect_hover_sounds()
	
func _connect_hover_sounds():
	var buttons = [
		$Panel_Container/Pause_Menu/VBoxContainer/ResumeButton,
		$Panel_Container/Pause_Menu/VBoxContainer/RestartButton,
		$Panel_Container/Pause_Menu/VBoxContainer/OptionsButton,
		$Panel_Container/Pause_Menu/VBoxContainer/LevelSelectButton,
		$Panel_Container/Pause_Menu/VBoxContainer/ExitMenuButton,
		$Panel_Container/Pause_Menu/VBoxContainer/ExitDesktopButton
	]
	for button in buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)

var pause_locked := false

func pause():
	visible = true # Make pause menu visible
	get_tree().paused = true # Pause the game
	Music_Controller.pause_music() # Optional: pause level music if you have this implemented
	Music_Controller.play_menu_music()  # Play pause menu music instead

func resume():
	visible = false
	get_tree().paused = false
	Music_Controller.resume_music()

# Mouse hover → play hover sound
func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()
	
func _on_resume_button_pressed() -> void:
	if pause_locked:
		return
	pause_locked = true
	Music_Controller.play_start_button()
	resume()
	await $AnimationPlayer.animation_finished
	pause_locked = false

func _on_pause_button_pressed() -> void:
	if pause_locked:
		return
	pause_locked = true
	print("Pause triggered")
	Music_Controller.play_exit_esc_button()
	pause()
	pause_locked = false

func _on_options_button_pressed() -> void:
	Music_Controller.play_menu_forward_button()
	get_tree().change_scene_to_file("res://Scenes/Options_Menu.tscn")
	
func _on_exit_menu_button_pressed() -> void:
		Music_Controller.play_menu_forward_button()
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")

func _unhandled_input(event):
	if pause_locked:
		return
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			_on_pause_button_pressed()
		else:
			_on_resume_button_pressed()



#Level Select Button → Level Select Menu
#func _on_level_select_button_pressed(toggled_on: bool) -> void:
#	if toggled_on:
#		Music_Controller.play_menu_forward_button()
#		get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
#	else:
#		Music_Controller.play_menu_back_button()

#Exit Button → Quit game
#func _on_Exit_Desktop_Button_pressed() -> void:
	#Music_Controller.play_exit_esc_button()
	#await get_tree().create_timer(0.8).timeout  # Wait half a second
	#get_tree().quit()
