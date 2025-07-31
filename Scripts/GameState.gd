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

# Use when starting a fresh game or restarting after Game Over
func full_reset():
	balls_left = DEFAULT_BALLS
	is_game_over = false

# Use when continuing to next level — keep ball count
func soft_reset():
	is_game_over = false
