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
	if level_completed:
		return

	# Get all remaining destructible blocks
	var remaining_blocks = get_tree().get_nodes_in_group("Block")

	if remaining_blocks.is_empty():
		level_completed = true
		await _on_level_complete()

func _on_level_complete() -> void:
	print("Level completed!")

	# Hide the ball(s)
	var balls = get_tree().get_nodes_in_group("Ball")
	for ball in balls:
		ball.hide()
		ball.set_process(false)
		ball.set_physics_process(false)

	# Play level complete music
	Music_Controller.play_level_complete_music()
	await get_tree().create_timer(6.0).timeout

	# Find the next level
	var current_path = get_tree().current_scene.scene_file_path
	var current_index = level_paths.find(current_path)

	if current_index != -1 and current_index + 1 < level_paths.size():
		var next_level = level_paths[current_index + 1]
		get_tree().change_scene_to_file(next_level)
	else:
		print("No more levels or current level not found.")
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
