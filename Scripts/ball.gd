extends RigidBody2D

@export var base_speed := 250.0
@export var velocity := Vector2(0, -250)
var is_locked := true
@onready var paddle: CharacterBody2D = $"../paddle"

func _physics_process(delta: float) -> void:
	if is_locked and paddle:
		# Keep ball in front of the paddle. Number at the end is distance from paddle.
		global_position = paddle.global_position - (paddle.global_position - paddle.center).normalized() * 12.0
	else:
		var collision_info = move_and_collide(velocity * delta, false, 0.08)
		if collision_info:
			var collider = collision_info.get_collider()
			var bounced_velocity = velocity.bounce(collision_info.get_normal())

			if collider == paddle:
				# Slightly assist the ball's direction toward the center
				var to_center = (paddle.center - global_position).normalized() * velocity.length()
				velocity = bounced_velocity.lerp(to_center, 0.2).normalized() * base_speed
			else:
				velocity = bounced_velocity

func _input(event: InputEvent) -> void:
	if is_locked and event.is_action_pressed("launch_ball") and paddle:
		is_locked = false
		var launch_direction = (paddle.center - paddle.global_position).normalized()
		velocity = launch_direction * velocity.length()
