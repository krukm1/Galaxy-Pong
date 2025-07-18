extends Control

func _ready() -> void:
	Music_Controller.play_menu_music()
	$Credits_Text.visible = false
	
	#Connect mouse_entered signal for all buttons
	var buttons = [
		$Panel_Container/Main_Menu/VBoxContainer/StartButton,
		$Panel_Container/Main_Menu/VBoxContainer/OptionsButton,
		$Panel_Container/Main_Menu/VBoxContainer/CreditsButton,
		$Panel_Container/Main_Menu/VBoxContainer/ExitButton
	]
	for button in buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
		
# Mouse hover → play hover sound
func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()

#Start Button → Game Level 1
func _on_start_button_pressed() -> void:
	Music_Controller.play_start_button()
	get_tree().change_scene_to_file("res://Scenes/Game_Level_1.tscn")

#Options button -> Options Menu
func _on_options_button_pressed() -> void:
	Music_Controller.play_menu_forward_button()
	get_tree().change_scene_to_file("res://Scenes/Options_Menu.tscn")

#Credits Toggle Button → Toggle Credits_Text visibility
func _on_credits_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Music_Controller.play_menu_forward_button()
	else:
		Music_Controller.play_menu_back_button()
	$Credits_Text.visible = toggled_on

#Exit Button → Quit game
func _on_exit_button_pressed() -> void:
	Music_Controller.play_exit_esc_button()
	await get_tree().create_timer(0.8).timeout  # Wait half a second
	get_tree().quit()
