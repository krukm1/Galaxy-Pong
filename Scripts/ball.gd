extends RigidBody2D

signal ball_lost  # ← Step 1: Define the signal

# --- Exported variables ---
@export var base_speed := 250.0  # The consistent speed the ball should maintain after bouncing
@export var velocity := Vector2(0, -250)  # The initial direction and speed of the ball (upward)

# --- Internal state ---
var is_locked := true  # While true, the ball stays attached in front of the paddle
@onready var paddle: CharacterBody2D = $"../paddle"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# --- Ball Combo Tracker ---
var add_ball_powerup_scene := preload("res://Scenes/add_ball_powerup.tscn")
var launch_grace_timer := 0.0

var combo_timer := 0.0
var combo_count := 0
var combo_window := 2  # Seconds allowed between hits

func _ready():
	contact_monitor = true
	set_physics_process_priority(1)
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	freeze = true
	collision_shape.disabled = true
	add_to_group("FadeOnGameStart")
	add_to_group("Ball")

func _exit_tree() -> void:
	if launch_grace_timer > 0.0:
		collision_shape.disabled = false

# --- Called every physics frame ---
func _physics_process(delta: float) -> void:
	if launch_grace_timer > 0.0:
		launch_grace_timer -= delta
		if launch_grace_timer <= 0.0:
			collision_shape.disabled = false

	#Combo Tracker
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_count = 0  # Combo expired
	# Lock the ball in front of the paddle until it's launched
	if is_locked and paddle:
		global_position = paddle.global_position - (paddle.global_position - paddle.center).normalized() * 13.0
	elif launch_grace_timer > 0.0:
		global_position += velocity * delta
	else:
		var collision_info = move_and_collide(velocity * delta, false, 0.08)

		if collision_info: # Get the object we collided with and the bounced direction
			var collider = collision_info.get_collider()
			var bounced_velocity = velocity.bounce(collision_info.get_normal())

			if collider == paddle:
				var to_center = (paddle.center - global_position).normalized() * velocity.length()
				velocity = bounced_velocity.lerp(to_center, 0.35).normalized() * base_speed
			
			elif collider.is_in_group("Block"):
				velocity = bounced_velocity.normalized() * base_speed

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
				velocity = bounced_velocity.normalized() * base_speed

				if collider.has_method("register_hit"):
					collider.register_hit()
				else:
					Music_Controller.play_block_indestructible()

			elif collider.is_in_group("Wall"):
				print("Ball destoyed — losing 1 ball life.")
				print("Lives remaining after: ", GameState.balls_left - 1)
				queue_free()
				emit_signal("ball_lost")
				return

			else:
				velocity = bounced_velocity.normalized() * base_speed

# --- Called when a player presses a key or button ---
func _input(event: InputEvent) -> void:
	# Launch the ball when the assigned input action ("launch_ball") is pressed
	if is_locked and event.is_action_pressed("launch_ball") and paddle:
		var launch_direction: Vector2 = (paddle.center - paddle.global_position).normalized()
		global_position = paddle.global_position + launch_direction * 25.0
		is_locked = false
		freeze = false
		linear_velocity = Vector2.ZERO
		launch_grace_timer = 0.5
		velocity = launch_direction * velocity.length()
