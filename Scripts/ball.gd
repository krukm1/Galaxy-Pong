extends CharacterBody2D

signal ball_lost

# --- Exported variables ---
@export var base_speed := 250.0
@export var ball_velocity := Vector2(0, -250)  # renamed from velocity

# --- Internal state ---
@onready var paddle: CharacterBody2D = $"../paddle"

# --- Ball Combo Tracker ---
var add_ball_powerup_scene := preload("res://Scenes/add_ball_powerup.tscn")
var combo_timer := 0.0
var combo_count := 0
var combo_window := 2  # Seconds allowed between hits

func _ready():
	add_to_group("FadeOnGameStart")
	add_to_group("Ball")

func _physics_process(delta: float) -> void:
	# Combo Tracker
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_count = 0
	else:
		# Move the ball according to its velocity and check for collisions
		var collision_info = move_and_collide(ball_velocity * delta, false, 0.08)

		if collision_info:
			var collider = collision_info.get_collider()
			var bounced_velocity = ball_velocity.bounce(collision_info.get_normal())

			if collider == paddle:
				var to_center = (paddle.center - global_position).normalized() * ball_velocity.length()
				ball_velocity = bounced_velocity.lerp(to_center, 0.35).normalized() * base_speed

			elif collider.is_in_group("Block"):
				ball_velocity = bounced_velocity.normalized() * base_speed
				combo_count += 1
				combo_timer = combo_window

				if combo_count >= 3:
					Music_Controller.play_add_ball_powerup_spawned()
					var powerup = add_ball_powerup_scene.instantiate()
					powerup.global_position = collider.global_position
					get_tree().current_scene.add_child(powerup)
					combo_count = 0

				if collider.has_method("register_hit"):
					collider.register_hit()
				elif collider.has_method("_on_destroyed"):
					Music_Controller.play_block_break()
					collider._on_destroyed()
				else:
					Music_Controller.play_block_break()
					collider.queue_free()

			elif collider.is_in_group("Block_Indestructible"):
				ball_velocity = bounced_velocity.normalized() * base_speed
				if collider.has_method("register_hit"):
					collider.register_hit()
				else:
					Music_Controller.play_block_indestructible()

			elif collider.is_in_group("Wall"):
				print("Ball destroyed — losing 1 ball life.")
				print("Lives remaining after: ", GameState.balls_left - 1)
				queue_free()
				emit_signal("ball_lost")
