extends Control

@onready var restart_button = $Game_Over_Menu/VBoxContainer/RestartButton
@onready var main_menu_button = $Game_Over_Menu/VBoxContainer/MainMenuButton
@onready var vbox = $Game_Over_Menu/VBoxContainer
@onready var title_label = $Game_Over_Menu/Title_Label

var can_hover := false
var fade_started := false
var interactivity_enabled := false

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	vbox.modulate.a = 0.0
	title_label.modulate.a = 0.0

	# Connect hover signals
	for button in [restart_button, main_menu_button]:
		button.mouse_entered.connect(_on_button_mouse_entered)

	# Connect button press signals
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func start_fade() -> void:
	visible = true
	modulate.a = 1.0  # Make the root Control node visible
	
	vbox.modulate.a = 0.0
	title_label.modulate.a = 0.0

	restart_button.disabled = true
	main_menu_button.disabled = true

	var tween = create_tween()
	tween.tween_property(title_label, "modulate:a", 1.0, 6.0)
	tween.tween_property(vbox, "modulate:a", 1.0, 2.0).set_delay(0.0)

	can_hover = false
	interactivity_enabled = false
	fade_started = true
	set_process(true)

func _process(_delta):
	if fade_started and not interactivity_enabled:
		if vbox.modulate.a >= 0.05:
			restart_button.disabled = false
			main_menu_button.disabled = false
			can_hover = true
			interactivity_enabled = true
			set_process(false)

func _on_button_mouse_entered() -> void:
	if can_hover:
		Music_Controller.play_button_hover()

func _on_restart_pressed() -> void:
	print("Restart button clicked")
	GameState.full_reset()
	Music_Controller.stop_music()
	Music_Controller.play_start_button()
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	print("Main Menu button clicked")
	Music_Controller.play_exit_esc_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
