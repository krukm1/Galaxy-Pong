extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("bottom_wall ready")

func _on_body_entered(body):
	print("Something entered bottom wall: ", body)
	if body and body.is_in_group("Ball"):
		print("Ball detected — life lost!")
		body.queue_free()
		GameState.balls_left -= 1

		if GameState.balls_left > 0:
			call_deferred("_respawn_ball")
		else:
			print("Game Over")

func _respawn_ball():
	var ball_scene = preload("res://Scenes/ball.tscn")
	var new_ball = ball_scene.instantiate()

	var paddle = get_parent().get_node("paddle")
	new_ball.paddle = paddle
	new_ball.is_locked = true
	new_ball.global_position = paddle.global_position - (paddle.global_position - paddle.center).normalized() * 12.0

	get_parent().add_child(new_ball)
