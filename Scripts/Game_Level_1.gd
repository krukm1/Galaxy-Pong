extends Node2D

@onready var paddle = $paddle  # or however you get your paddle node
@onready var ball_scene = preload("res://Scenes/ball.tscn")

func _ready() -> void:
	Music_Controller.play_level1_music()
	_respawn_ball()

func _respawn_ball():
	var new_ball = ball_scene.instantiate()
	new_ball.paddle = paddle
	new_ball.is_locked = true
	new_ball.global_position = paddle.global_position - (paddle.global_position - paddle.center).normalized() * 12.0
	add_child(new_ball)
	new_ball.connect("ball_lost", Callable(self, "_on_ball_lost"))  # ← Step 3: Connect the signal

func _on_ball_lost():
	GameState.balls_left -= 1
	if GameState.balls_left > 0:
		_respawn_ball()
	else:
		print("Game Over")
		Music_Controller.play_game_over_music()   
		await get_tree().create_timer(6.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
		# TODO: show a retry screen or restart

#WORKING ON PAUSE BUTTON
#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#Music_Controller.play_exit_esc_button()
		## Toggle pause
		#get_tree().paused = not get_tree().paused
		## Show or hide pause menu depending on state
		#if get_tree().paused:
			#show()
		#else:
			#hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Music_Controller.play_exit_esc_button()
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")
