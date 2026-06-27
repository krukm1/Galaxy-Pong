extends Node

var balls_left := 3
var is_game_over := false

var level_unlocks := {
	"level_1": true,
	"level_2": false,
	"level_3": false,
	"level_4": false,
	"level_5": false,
	"level_6": false,
	"level_7": false,
	"level_8": false,
	"level_9": false,
	"level_10": false
}

const DEFAULT_BALLS := 3
const SAVE_PATHS: Array[String] = ["user://save_slot_0.json", "user://save_slot_1.json"]
const LAST_SLOT_PATH := "user://last_slot.json"
var current_slot := -1

func _ready() -> void:
	try_load_last_slot()

# Use when starting a fresh game or restarting after Game Over
func full_reset() -> void:
	balls_left = DEFAULT_BALLS
	is_game_over = false

# Use when continuing to next level — keep ball count
func soft_reset() -> void:
	is_game_over = false

func unlock_level(level_number: int) -> void:
	var key := "level_%d" % level_number
	if level_unlocks.has(key):
		level_unlocks[key] = true
		print("Unlocked: ", key)
		save_game()
	else:
		print("Level key not found:", key)

func save_game() -> void:
	if current_slot < 0:
		return
	var data := {"level_unlocks": level_unlocks}
	var file := FileAccess.open(SAVE_PATHS[current_slot], FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
	var last_file := FileAccess.open(LAST_SLOT_PATH, FileAccess.WRITE)
	if last_file:
		last_file.store_string(JSON.stringify({"slot": current_slot}))

func load_slot(slot: int) -> bool:
	if slot < 0 or slot >= SAVE_PATHS.size():
		return false
	current_slot = slot
	if not FileAccess.file_exists(SAVE_PATHS[slot]):
		level_unlocks = _default_unlocks()
		return false
	var file := FileAccess.open(SAVE_PATHS[slot], FileAccess.READ)
	if not file:
		return false
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return false
	var data: Dictionary = json.get_data()
	if data.has("level_unlocks"):
		level_unlocks = data["level_unlocks"]
	return true

func clear_slot(slot: int) -> void:
	if slot < 0 or slot >= SAVE_PATHS.size():
		return
	var dir := DirAccess.open("user://")
	if dir:
		dir.remove(SAVE_PATHS[slot].get_file())
	if current_slot == slot:
		current_slot = -1
		level_unlocks = _default_unlocks()
		var last_dir := DirAccess.open("user://")
		if last_dir:
			last_dir.remove(LAST_SLOT_PATH.get_file())

func get_slot_info(slot: int) -> Dictionary:
	if slot < 0 or slot >= SAVE_PATHS.size():
		return {"exists": false, "highest_level": 1}
	if not FileAccess.file_exists(SAVE_PATHS[slot]):
		return {"exists": false, "highest_level": 1}
	var file := FileAccess.open(SAVE_PATHS[slot], FileAccess.READ)
	if not file:
		return {"exists": false, "highest_level": 1}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return {"exists": false, "highest_level": 1}
	var data: Dictionary = json.get_data()
	var unlocks: Dictionary = data.get("level_unlocks", {})
	var highest := 1
	for i in range(1, 11):
		if unlocks.get("level_%d" % i, false):
			highest = i
	return {"exists": true, "highest_level": highest}

func try_load_last_slot() -> void:
	if not FileAccess.file_exists(LAST_SLOT_PATH):
		return
	var file := FileAccess.open(LAST_SLOT_PATH, FileAccess.READ)
	if not file:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	var data: Dictionary = json.get_data()
	var slot: int = data.get("slot", -1)
	if slot >= 0:
		load_slot(slot)

func _default_unlocks() -> Dictionary:
	return {
		"level_1": true,
		"level_2": false,
		"level_3": false,
		"level_4": false,
		"level_5": false,
		"level_6": false,
		"level_7": false,
		"level_8": false,
		"level_9": false,
		"level_10": false
	}
