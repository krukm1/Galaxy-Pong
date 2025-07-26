extends Node

@onready var pause_menu := $Pause_Menu
@onready var paddle = get_tree().current_scene.get_node("paddle")
@onready var ball_scene = preload("res://Scenes/ball.tscn")

func _ready():
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

func _unhandled_input(event):
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
		Music_Controller.play_game_over_music()
		await get_tree().create_timer(25.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
