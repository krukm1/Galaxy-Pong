extends Node

var balls_left := 3
const SAVE_PATH := "user://save_data.cfg"

func _ready() -> void:
	_initialize_save_file()

# Unlock a new level if it hasn’t already been unlocked
func unlock_level(level_number: int) -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)

	if err != OK:
		config.set_value("Progress", "highest_unlocked", 1)  # default value

	var current_highest = int(config.get_value("Progress", "highest_unlocked", 1))

	if level_number > current_highest:
		config.set_value("Progress", "highest_unlocked", level_number)
		config.save(SAVE_PATH)

# Returns the highest unlocked level (default: 1)
func get_unlocked_level() -> int:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)

	if err == OK:
		return int(config.get_value("Progress", "highest_unlocked", 1))
	return 1

# Ensures the save file exists with at least level 1 unlocked
func _initialize_save_file() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)

	if err != OK:
		config.set_value("Progress", "highest_unlocked", 1)
		config.save(SAVE_PATH)
