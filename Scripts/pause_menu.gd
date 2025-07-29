extends Control

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var restart_button = $VBoxContainer/RestartButton
@onready var main_menu_button = $VBoxContainer/MainMenuButton
@onready var ball_lives_label = $ball_lives_counter

func _ready() -> void:
	set_process_unhandled_input(true)
	
	visible = false
	
	# Connect button pressed signals
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	# Connect mouse hover signals to play hover sound
	var buttons = [
		resume_button,
		restart_button,
   		main_menu_button
	]
	for button in buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)

# Mouse hover → play hover sound
func _on_button_mouse_entered():
	Music_Controller.play_button_hover()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Esc pressed - visible:", visible, " | paused:", get_tree().paused)
		if visible:
			_on_resume_pressed()

func show_pause_menu():
	update_ball_lives_display()
	Music_Controller.play_menu_back_button()
	get_tree().paused = true
	Music_Controller.play_pause_menu_music()
	visible = true

func _on_resume_pressed() -> void:
	print("Resume button clicked")
	Music_Controller.play_menu_forward_button()
	visible = false
	await get_tree().process_frame  # Let UI logic finish
	get_tree().paused = false

func _on_restart_pressed() -> void:
	print("Restart button clicked")
	get_tree().paused = false  # Unpause before reloading
	Music_Controller.stop_music()  # Add this line
	Music_Controller.play_exit_esc_button()
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	print("Main Menu button clicked")
	get_tree().paused = false  # ✅ unpause BEFORE switching scenes
	Music_Controller.play_exit_esc_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func update_ball_lives_display() -> void:
	ball_lives_label.text = "%d ball lives left" % GameState.balls_left
