extends Control

@onready var slot0_info: Label = $SlotsContainer/Slot0Panel/InfoLabel
@onready var slot1_info: Label = $SlotsContainer/Slot1Panel/InfoLabel
@onready var slot0_clear: Button = $SlotsContainer/Slot0Panel/ClearButton
@onready var slot1_clear: Button = $SlotsContainer/Slot1Panel/ClearButton

func _ready() -> void:
	Music_Controller.play_menu_music()
	_refresh_slots()

func _refresh_slots() -> void:
	for slot in range(2):
		var info := GameState.get_slot_info(slot)
		var info_label: Label = slot0_info if slot == 0 else slot1_info
		var clear_btn: Button = slot0_clear if slot == 0 else slot1_clear
		if info["exists"]:
			info_label.text = "Level %d reached" % info["highest_level"]
			clear_btn.visible = true
		else:
			info_label.text = "New Game"
			clear_btn.visible = false

func _on_play_slot_0_pressed() -> void:
	_start_slot(0)

func _on_play_slot_1_pressed() -> void:
	_start_slot(1)

func _start_slot(slot: int) -> void:
	var info := GameState.get_slot_info(slot)
	GameState.load_slot(slot)
	GameState.full_reset()
	var level := info["highest_level"] if info["exists"] else 1
	get_tree().change_scene_to_file("res://Scenes/Game_Level_%d.tscn" % level)

func _on_clear_slot_0_pressed() -> void:
	GameState.clear_slot(0)
	_refresh_slots()

func _on_clear_slot_1_pressed() -> void:
	GameState.clear_slot(1)
	_refresh_slots()

func _on_back_button_pressed() -> void:
	Music_Controller.play_menu_back_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()
