extends Control

@onready var resume_button = $VBoxContainer/ResumeButton
@onready var main_menu_button = $VBoxContainer/MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	set_process_unhandled_input(true)
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Esc pressed - visible:", visible, " | paused:", get_tree().paused)
	if event.is_action_pressed("ui_cancel") and visible:
		_on_resume_pressed()

func show_pause_menu():
	get_tree().paused = true
	visible = true

func _on_resume_pressed() -> void:
	print("Resume button clicked")
	visible = false
	await get_tree().process_frame  # Let UI logic finish
	get_tree().paused = false
	
func _on_main_menu_pressed() -> void:
	print("Main Menu button clicked")
	get_tree().paused = false  # ✅ unpause BEFORE switching scenes
	Music_Controller.play_exit_esc_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
