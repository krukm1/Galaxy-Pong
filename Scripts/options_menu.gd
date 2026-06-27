extends Control

func _ready() -> void:
	Music_Controller.play_menu_music()
		#Connect mouse_entered signal for all buttons
	var buttons = [
		$"PanelContainer/Main Menu/VBoxContainer/BackButton",
	]
	for button in buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)

# Mouse hover → play hover sound
func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()

#Back Button takes you back to Main Menu
func _on_back_button_pressed() -> void:
	Music_Controller.play_menu_back_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
