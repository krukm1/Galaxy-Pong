extends Area2D

func _ready():
	add_to_group("Wall")
	add_to_group("FadeOnGameStart")
	add_to_group("FadeOnGameOver")
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Ball"):
		print("Ball destoyed — losing 1 ball life.")
		print("Lives remaining after: ", GameState.balls_left - 1)
		body.queue_free()
		body.emit_signal("ball_lost")
