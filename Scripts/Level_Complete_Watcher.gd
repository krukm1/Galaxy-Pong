extends Node

var remaining_blocks := 0
var level_completed := false
var game_controller = null

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

func _ready():
	# Get the GameController node safely after scene loads
	game_controller = get_tree().current_scene.get_node("GameController")
	
	await get_tree().process_frame  # <-- allow one frame for blocks to appear
	# Count all destructible blocks
	var blocks = get_tree().get_nodes_in_group("Block")
	remaining_blocks = blocks.size()
	print("Blocks found:", remaining_blocks)

	# Connect their destruction signals
	for block in blocks:
		if block.has_signal("block_destroyed"):
			block.connect("block_destroyed", self._on_block_destroyed)

func _on_block_destroyed():
	remaining_blocks -= 1
	if remaining_blocks <= 0 and not level_completed:
		level_completed = true
		await _on_level_complete()

func _on_level_complete() -> void:
	print("Level completed!")
	
	var current_scene = get_tree().current_scene
	var match = current_scene.name.match("^Game_Level_(\\d+)$")
	if match:
		var current_level = int(match[1])
		GameState.unlock_level(current_level + 1)
		game_controller.level_complete(current_level)

	var balls = get_tree().get_nodes_in_group("Ball")
	for ball in balls:
		ball.hide()
		ball.set_process(false)
		ball.set_physics_process(false)

	Music_Controller.play_level_complete_music()
	await get_tree().create_timer(6.0).timeout

	var current_path = get_tree().current_scene.scene_file_path
	var current_index = level_paths.find(current_path)

	if current_index != -1 and current_index + 1 < level_paths.size():
		var next_level = level_paths[current_index + 1]
		get_tree().change_scene_to_file(next_level)
	else:
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
