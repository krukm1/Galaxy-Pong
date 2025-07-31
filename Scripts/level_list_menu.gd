extends Control

@onready var back_button = $BackButton
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
	
		# Connect button pressed signals
	level_1.pressed.connect(_on_level_selected.bind(1))
	level_2.pressed.connect(_on_level_selected.bind(2))
	level_3.pressed.connect(_on_level_selected.bind(3))
	level_4.pressed.connect(_on_level_selected.bind(4))
	level_5.pressed.connect(_on_level_selected.bind(5))
	level_6.pressed.connect(_on_level_selected.bind(6))
	level_7.pressed.connect(_on_level_selected.bind(7))
	level_8.pressed.connect(_on_level_selected.bind(8))
	level_9.pressed.connect(_on_level_selected.bind(9))
	level_10.pressed.connect(_on_level_selected.bind(10))
	
	# Connect mouse hover signals to play hover sound
	var buttons = [
	level_1,
	level_2,
	level_3,
	level_4,
	level_5,
	level_6,
	level_7,
	level_8,
	level_9,
	level_10
	]

	for i in range(buttons.size()):
		var button = buttons[i]
		var level_num = i + 1
		var level_key = "level_%d" % level_num

		# Enable or disable based on unlock state
		var is_unlocked = GameState.level_unlocks.get(level_key, false)
		button.disabled = not is_unlocked

		# Optional: visually mark locked buttons (gray out, change text, etc.)
		# Example: if not is_unlocked: button.text = "Locked"

		# Connect signals
		if not button.pressed.is_connected(_on_level_selected):
			button.pressed.connect(_on_level_selected.bind(level_num))
		if not button.mouse_entered.is_connected(_on_button_mouse_entered):
			button.mouse_entered.connect(_on_button_mouse_entered)
	
	# Back button setup
	back_button.pressed.connect(_on_back_button_pressed)
	back_button.mouse_entered.connect(_on_button_mouse_entered)
	
func _on_level_selected(level_number: int):
	var level_path = "res://Scenes/Game_Level_%d.tscn" % level_number
	get_tree().change_scene_to_file(level_path)
	
func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()
	
func _on_back_button_pressed() -> void:
	Music_Controller.play_menu_back_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
