extends Node

var level_completed := false
var level_paths := [
	"res://Scenes/Game_Level_1.tscn",
	"res://Scenes/Game_Level_2.tscn",
	"res://Scenes/Game_Level_3.tscn",
	"res://Scenes/Game_Level_4.tscn",
	"res://Scenes/Game_Level_5.tscn",
	"res://Scenes/Game_Level_6.tscn",
	"res://Scenes/Game_Level_7.tscn",
	"res://Scenes/Game_Level_8.tscn",
	"res://Scenes/Game_Level_9.tscn",
	"res://Scenes/Game_Level_10.tscn",
]

func _process(_delta):
	if not level_completed and get_child_count() == 0:
		level_completed = true

		# Hide the ball
		var balls = get_tree().get_nodes_in_group("Ball")
		for ball in balls:
			ball.hide()
			ball.set_process(false)
			ball.set_physics_process(false)

		#play level complete music and wait 5 seconds
		Music_Controller.play_level_complete_music()
		await get_tree().create_timer(6.0).timeout
		
		# Get current scene path
		var current_path = get_tree().current_scene.scene_file_path
		
		# Find the index of the current scene in the list
		var current_index = level_paths.find(current_path)

		# Load the next level if it exists
		if current_index != -1 and current_index + 1 < level_paths.size():
			var next_level = level_paths[current_index + 1]
			get_tree().change_scene_to_file(next_level)
		else:
			print("No more levels or current level not found.")
			# Optionally return to main menu or show "You Win" screen
			# get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
