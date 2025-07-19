extends RigidBody2D

@export var velocity := Vector2(0, -250) # Upward velocity by default
var is_locked := true
var paddle: CharacterBody2D = null

func _physics_process(delta: float) -> void:
	if is_locked and paddle:
		# Keep ball in front of the paddle
		global_position = paddle.global_position + (paddle.global_position - paddle.center).normalized() * 20.0
	else:
		var collision_info = move_and_collide(velocity * delta, false, 0.08)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())

func _input(event: InputEvent) -> void:
	if is_locked and event.is_action_pressed("ui_accept"): # e.g., Spacebar
		is_locked = false
