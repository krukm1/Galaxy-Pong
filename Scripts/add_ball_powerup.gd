extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	add_to_group("FadeOnGameOver")
	
func _on_body_entered(body):
	if body.name == "paddle":  # Adjust name as needed
		GameState.balls_left += 1
		# You can also call Music_Controller.play_ball_bonus() if you want an SFX
		queue_free()
