extends Node

@onready var pause_menu := $Pause_Menu
@onready var paddle = get_tree().current_scene.get_node("paddle")
@onready var ball_scene = preload("res://Scenes/ball.tscn")
@onready var game_over_screen := $Game_Over
@onready var lives_label: Label = $HUD/LivesLabel

@onready var tilemap_container = get_tree().current_scene.get_node("TileMapLayer")

var _last_balls_left := -1

var block_scene := preload("res://Scenes/block.tscn")
var block_white_scene := preload("res://Scenes/block_white.tscn")
var block_2hit_scene := preload("res://Scenes/block_2hit.tscn")

func _ready():
	GameState.is_game_over = false
	replace_tiles_with_blocks()
	# Start level music based on level name
	var level_name = get_tree().current_scene.name
	match level_name:
		"Game_Level_1":
			Music_Controller.play_level1_music()
		"Game_Level_2":
			Music_Controller.play_level2_music()
		"Game_Level_3":
			Music_Controller.play_level3_music()
		"Game_Level_4":
			Music_Controller.play_level4_music()
		"Game_Level_5":
			Music_Controller.play_level5_music()
		"Game_Level_6":
			Music_Controller.play_level6_music()
		"Game_Level_7":
			Music_Controller.play_level7_music()
		"Game_Level_8":
			Music_Controller.play_level8_music()
		"Game_Level_9":
			Music_Controller.play_level9_music()
		"Game_Level_10":
			Music_Controller.play_level10_music()
		# Add more levels as needed

func _process(_delta: float) -> void:
	if GameState.balls_left != _last_balls_left:
		_last_balls_left = GameState.balls_left
		lives_label.text = "%d ball lives left" % GameState.balls_left

func _fade_in_nodes():
	for node in get_tree().get_nodes_in_group("FadeOnGameStart"):
		if node is CanvasItem:
			node.modulate.a = 0.0
			var tween := create_tween()
			tween.tween_property(node, "modulate:a", 1.0, 2)

func _fade_out_nodes():
	for node in get_tree().get_nodes_in_group("FadeOnGameOver"):
		if node is CanvasItem:
			var tween := create_tween()
			tween.tween_property(node, "modulate:a", 0.0, 5)

func level_complete(current_level: int):
	GameState.is_game_over = true  # Prevent pause
	_fade_out_nodes()  # Fade out all FadeOnGameOver nodes
	await get_tree().create_timer(3.0).timeout  # Wait for fade-out to finish

	var next_level = current_level + 1
	var next_level_path = "res://Scenes/Game_Level_%d.tscn" % next_level

	get_tree().change_scene_to_file(next_level_path)

func _unhandled_input(event):
	if GameState.is_game_over:
		return
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu._on_resume_pressed()
		else:
			pause_menu.show_pause_menu()
			
func spawn_ball():
	var new_ball = ball_scene.instantiate()
	new_ball.paddle = paddle
	new_ball.is_locked = true
	new_ball.global_position = paddle.global_position - (paddle.global_position - paddle.center).normalized() * 12.0
	get_tree().current_scene.add_child(new_ball)
	new_ball.connect("ball_lost", Callable(self, "_on_ball_lost"))

func _on_ball_lost():
	GameState.balls_left -= 1
	if GameState.balls_left > 0:
		Music_Controller.play_ball_lost()
		spawn_ball()
	else:
		print("Game Over")
		GameState.is_game_over = true
		Music_Controller.play_game_over_music()
		_fade_out_nodes()

		game_over_screen.start_fade()

func replace_tiles_with_blocks():
	for tilemap_layer in tilemap_container.get_children():
		if tilemap_layer is TileMapLayer:
			for cell in tilemap_layer.get_used_cells():
				var tile_id = tilemap_layer.get_cellv(cell)
				var scene_to_spawn : PackedScene = null
				
				match tile_id:
					1:
						scene_to_spawn = block_scene
					2:
						scene_to_spawn = block_2hit_scene
					3:
						scene_to_spawn = block_white_scene
					_:
						continue
				
				var block_instance = scene_to_spawn.instantiate()
				block_instance.global_position = tilemap_layer.map_to_world(cell)
				tilemap_container.get_parent().add_child(block_instance)
				tilemap_layer.set_cellv(cell, -1)
