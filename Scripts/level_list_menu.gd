extends Control

@onready var back_button: Button = $BackButton
@onready var debug_unlock_button: Button = $DebugUnlockAllButton
@onready var level_1: Button = $LevelListContainer1/Level_1
@onready var level_2: Button = $LevelListContainer1/Level_2
@onready var level_3: Button = $LevelListContainer1/Level_3
@onready var level_4: Button = $LevelListContainer1/Level_4
@onready var level_5: Button = $LevelListContainer1/Level_5
@onready var level_6: Button = $LevelListContainer2/Level_6
@onready var level_7: Button = $LevelListContainer2/Level_7
@onready var level_8: Button = $LevelListContainer2/Level_8
@onready var level_9: Button = $LevelListContainer2/Level_9
@onready var level_10: Button = $LevelListContainer2/Level_10

func _ready() -> void:
	Music_Controller.play_menu_music()

	debug_unlock_button.pressed.connect(_on_debug_unlock_all_pressed)
	debug_unlock_button.mouse_entered.connect(func(): Music_Controller.play_button_hover())

	var level_buttons: Array[Button] = [level_1, level_2, level_3, level_4, level_5,
										level_6, level_7, level_8, level_9, level_10]
	for i in range(level_buttons.size()):
		var button: Button = level_buttons[i]
		var level_num := i + 1
		button.pressed.connect(_on_level_selected.bind(level_num))
		button.mouse_entered.connect(func(): _on_button_mouse_entered(button))

	_refresh_button_states()

func _refresh_button_states() -> void:
	var level_buttons: Array[Button] = [level_1, level_2, level_3, level_4, level_5,
										level_6, level_7, level_8, level_9, level_10]
	for i in range(level_buttons.size()):
		var level_key := "level_%d" % (i + 1)
		level_buttons[i].disabled = not GameState.level_unlocks.get(level_key, false)

func _on_debug_unlock_all_pressed() -> void:
	for i in range(1, 11):
		GameState.unlock_level(i)
	_refresh_button_states()

func _on_level_selected(level_number: int) -> void:
	get_tree().change_scene_to_file("res://Scenes/Game_Level_%d.tscn" % level_number)

func _on_button_mouse_entered(button: Button) -> void:
	var level_key := button.name.to_lower()
	if GameState.level_unlocks.get(level_key, false):
		Music_Controller.play_button_hover()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()

func _on_back_button_pressed() -> void:
	Music_Controller.play_menu_back_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func _on_back_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()
