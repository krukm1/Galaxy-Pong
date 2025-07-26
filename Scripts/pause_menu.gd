extends Control

@onready var resume_button = $VBoxContainer/ResumeButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)

func show_pause_menu():
	get_tree().paused = true
	visible = true

func _on_resume_pressed() -> void:
	print("Resume button clicked")
	visible = false
	get_tree().paused = false
