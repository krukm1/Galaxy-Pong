extends Control

@onready var button_container = $LevelListContainer1
@onready var back_button = $BackButton

const TOTAL_LEVELS := 10  # Adjust to match how many levels you have

func _ready() -> void:
	Music_Controller.play_menu_music()
	_update_level_buttons()
	
	#Connect mouse_entered signal for all buttons
	back_button.mouse_entered.connect(_on_button_mouse_entered)

func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()

func _on_back_button_pressed() -> void:
	Music_Controller.play_menu_back_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
	
# --- Show/hide level buttons based on unlocked progress ---
func _update_level_buttons():
	var unlocked = _get_unlocked_level()

	for i in range(1, TOTAL_LEVELS + 1):
		var button_name = "Level%d" % i
		if button_container.has_node(button_name):
			var btn = button_container.get_node(button_name)
			btn.visible = i <= unlocked
			btn.disabled = i > unlocked
			btn.pressed.connect(_on_level_selected.bind(i))
			btn.mouse_entered.connect(_on_button_mouse_entered)

func _on_level_selected(level_number: int):
	var level_path = "res://Scenes/Game_Level_%d.tscn" % level_number
	get_tree().change_scene_to_file(level_path)

func _get_unlocked_level() -> int:
	var config = ConfigFile.new()
	var err = config.load("user://save_data.cfg")
	if err == OK:
		return int(config.get_value("Progress", "highest_unlocked", 1))
	return 1
