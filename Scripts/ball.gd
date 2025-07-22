extends RigidBody2D

# --- Exported variables ---
@export var base_speed := 250.0  # The consistent speed the ball should maintain after bouncing
@export var velocity := Vector2(0, -250)  # The initial direction and speed of the ball (upward)

# --- Internal state ---
var is_locked := true  # While true, the ball stays attached in front of the paddle
@onready var paddle: CharacterBody2D = $"../paddle"  # Reference to the paddle node (assumes it's a sibling)

func _ready():
	contact_monitor = true
	add_to_group("Ball")
	print("Ball ready and added to group")
	print("Ball groups: ", get_groups())

# --- Called every physics frame ---
func _physics_process(delta: float) -> void:		
	if is_locked and paddle: 		# Lock the ball in front of the paddle until it's launched
		# The 12.0 defines the distance between the ball and paddle face
		global_position = paddle.global_position - (paddle.global_position - paddle.center).normalized() * 12.0
	else:
		# Move the ball according to its velocity and check for collisions
		var collision_info = move_and_collide(velocity * delta, false, 0.08)

		if collision_info: # Get the object we collided with and the bounced direction
			var collider = collision_info.get_collider()
			var bounced_velocity = velocity.bounce(collision_info.get_normal())

			if collider == paddle:
				# If the paddle was hit, gently nudge the bounce direction toward the center to help keep the ball in play longer
				var to_center = (paddle.center - global_position).normalized() * velocity.length()
				# Blend the bounce with the assist vector, then normalize to maintain constant speed.
				velocity = bounced_velocity.lerp(to_center, 0.35).normalized() * base_speed
			elif collider.is_in_group("Wall"):
				print("Ball hit wall — losing life.")
				Music_Controller.play_ball_lost()
				queue_free()
				GameState.balls_left -= 1
				if GameState.balls_left > 0:
					get_parent().call_deferred("_respawn_ball")  # Make sure this exists
				else:
					print("Game Over")
			else:
				velocity = bounced_velocity.normalized() * base_speed

# --- Called when a player presses a key or button ---
func _input(event: InputEvent) -> void:
	# Launch the ball when the assigned input action ("launch_ball") is pressed
	if is_locked and event.is_action_pressed("launch_ball") and paddle:
		is_locked = false  # Unlock the ball so it starts moving
		var launch_direction = (paddle.center - paddle.global_position).normalized()
		velocity = launch_direction * velocity.length()  # Launch in the paddle’s facing direction
