extends RigidBody2D

@export var velocity:= Vector2(0,250) # How fast the ball will move.

func _physics_process(delta: float) -> void:
	
	var collision_info = move_and_collide(velocity * delta,false,0.08)
	if collision_info: 
		#print("Ball collided")
		velocity = velocity.bounce(collision_info.get_normal())
		if  collision_info.get_collider().is_in_group("asteroid"):
			print("Ball collided with Asteroid")
			velocity = velocity.bounce(collision_info.get_normal())
			collision_info.get_collider().queue_free()

func _on_asteroid_ball_bounce(delta) -> void:
	var collision_info = move_and_collide(velocity * delta,false,0.15)
	velocity = velocity.bounce(collision_info.get_normal())
	print("Ball collided with Asteroid")
