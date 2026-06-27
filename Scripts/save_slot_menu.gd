extends Control

@onready var slot0_info: Label = $SlotsContainer/Slot0Panel/InfoLabel
@onready var slot1_info: Label = $SlotsContainer/Slot1Panel/InfoLabel
@onready var slot0_clear: Button = $SlotsContainer/Slot0Panel/ButtonRow/ClearButton
@onready var slot1_clear: Button = $SlotsContainer/Slot1Panel/ButtonRow/ClearButton
@onready var confirm_dialog: ConfirmationDialog = $ConfirmDialog

var _pending_clear_slot := -1

func _ready() -> void:
	Music_Controller.play_menu_music()
	# Clear buttons get their own hover handler so sound is gated on disabled state
	for btn in [slot0_clear, slot1_clear]:
		btn.mouse_entered.disconnect(_on_button_mouse_entered)
		btn.mouse_entered.connect(_on_clear_button_mouse_entered.bind(btn))
	_refresh_slots()

func _refresh_slots() -> void:
	for slot in range(2):
		var info := GameState.get_slot_info(slot)
		var info_label: Label = slot0_info if slot == 0 else slot1_info
		var clear_btn: Button = slot0_clear if slot == 0 else slot1_clear
		clear_btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if info["exists"]:
			info_label.text = "Level %d reached" % info["highest_level"]
			clear_btn.disabled = false
			clear_btn.add_theme_color_override("font_color", Color(1.0, 0.45, 0.45, 1.0))
			clear_btn.add_theme_color_override("font_hover_color", Color(1.0, 0.05, 0.05, 1.0))
			clear_btn.add_theme_color_override("font_pressed_color", Color(1.0, 0.05, 0.05, 1.0))
		else:
			info_label.text = "New Game"
			clear_btn.disabled = true
			clear_btn.remove_theme_color_override("font_color")
			clear_btn.remove_theme_color_override("font_hover_color")
			clear_btn.remove_theme_color_override("font_pressed_color")

func _on_play_slot_0_pressed() -> void:
	_start_slot(0)

func _on_play_slot_1_pressed() -> void:
	_start_slot(1)

func _start_slot(slot: int) -> void:
	var info := GameState.get_slot_info(slot)
	GameState.load_slot(slot)
	GameState.full_reset()
	var level: int = info["highest_level"] if info["exists"] else 1
	get_tree().change_scene_to_file("res://Scenes/Game_Level_%d.tscn" % level)

func _on_clear_slot_0_pressed() -> void:
	_pending_clear_slot = 0
	confirm_dialog.popup_centered()

func _on_clear_slot_1_pressed() -> void:
	_pending_clear_slot = 1
	confirm_dialog.popup_centered()

func _on_confirm_dialog_confirmed() -> void:
	if _pending_clear_slot >= 0:
		GameState.clear_slot(_pending_clear_slot)
		_pending_clear_slot = -1
		_refresh_slots()

func _on_clear_button_mouse_entered(btn: Button) -> void:
	if not btn.disabled:
		Music_Controller.play_button_hover()

func _on_back_button_pressed() -> void:
	Music_Controller.play_menu_back_button()
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func _on_button_mouse_entered() -> void:
	Music_Controller.play_button_hover()
