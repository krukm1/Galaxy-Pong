extends CharacterBody2D

var speed = 300
var dir = Vector2.ZERO
var is_active = false  # Start inactive
var launched = false

func _ready() -> void:
	velocity = Vector2.ZERO  # Don't move until launched

func launch_toward(target: Vector2) -> void:
	if launched:
		return
	launched = true
	is_active = true
	dir = (target - global_position).normalized()
	velocity = dir * speed

func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			velocity = velocity.bounce(collision.get_normal())

		# Prevent weak downward movement
		if velocity.y > 0 and velocity.y < 100:
			velocity.y = -200

		# Prevent stuck horizontal movement
		if velocity.x == 0:
			velocity.x = -200
