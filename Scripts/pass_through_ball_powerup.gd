extends Area2D

@export var speed := 80.0
@export var rotation_speed := 10.0  # degrees per second
var velocity := Vector2.ZERO

func _ready():
	add_to_group("FadeOnGameOver")
	# Random direction in a full 360° circle
	var random_angle_rad = randf_range(0.0, TAU)  # TAU is 2π radians (360°)
	velocity = Vector2.RIGHT.rotated(random_angle_rad) * speed

func _process(delta):
	position += velocity * delta
	rotation_degrees += rotation_speed * delta  # 🔄 slowly rotate over time
	# Despawn if it goes too far off screen
	var screen_size = get_viewport_rect().size
	if position.x < -100 or position.x > screen_size.x + 100 or position.y > screen_size.y + 100:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Paddle"):
		#GameState.balls_left += 1  # Or trigger spawn_ball()
		print("gained pass through ball")
		Music_Controller.play_add_ball_powerup()
		queue_free()
