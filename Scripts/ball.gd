extends RigidBody2D

signal ball_lost  # ← Step 1: Define the signal

# --- Exported variables ---
@export var base_speed := 250.0  # The consistent speed the ball should maintain after bouncing
@export var velocity := Vector2(0, -250)  # The initial direction and speed of the ball (upward)

# --- Internal state ---
@onready var paddle: CharacterBody2D = $"../paddle"  # Reference to the paddle node (assumes it's a sibling)

# --- Ball Combo Tracker ---
var add_ball_powerup_scene := preload("res://Scenes/add_ball_powerup.tscn")
var combo_timer := 0.0
var combo_count := 0
var combo_window := 2  # Seconds allowed between hits

func _ready():
	contact_monitor = true
	add_to_group("FadeOnGameStart")
	add_to_group("Ball")

# --- Called every physics frame ---
func _physics_process(delta: float) -> void:
	#Combo Tracker
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_count = 0  # Combo expired

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
				# ... collision logic ...
			
			#Ball needs to hit Block_2hit twice and bounces off each time
			if collider.is_in_group("Block"):
				velocity = bounced_velocity.normalized() * base_speed
				
				# Combo logic
				combo_count += 1
				combo_timer = combo_window
				
				if combo_count >= 3:
					# Spawn powerup from this block
					Music_Controller.play_add_ball_powerup_spawned()
					var powerup = add_ball_powerup_scene.instantiate()
					powerup.global_position = collider.global_position
					get_tree().current_scene.add_child(powerup)

					combo_count = 0  # Reset combo after reward

				if collider.has_method("register_hit"):
					collider.register_hit()  # Let block_2hit decide what to do
				elif collider.has_method("_on_destroyed"):
					Music_Controller.play_block_break()
					collider._on_destroyed()  # ✅ properly emit signal before freeing
				else:
					Music_Controller.play_block_break()
					collider.queue_free()  # fallback, not ideal
			
			if collider.is_in_group("Block_Indestructible"):
				velocity = bounced_velocity.normalized() * base_speed

				if collider.has_method("register_hit"):
					collider.register_hit()  # Let the block decide what to do
				else:
					Music_Controller.play_block_indestructible()
				
			if collider.is_in_group("Wall"):
					print("Ball destoyed — losing 1 ball life.")
					print("Lives remaining after: ", GameState.balls_left - 1)
					queue_free()
					emit_signal("ball_lost")
					return  # Stop further code execution for this frame
