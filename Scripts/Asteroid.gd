extends RigidBody2D

signal destroyed
signal ball_bounce

@export var MAX_HEALTH := 1.0
var health : float
var collision_margin = 0.05
var velocity = Vector2(0,0)


func _physics_process(delta: float) -> void:
	velocity = $".".velocity
	var collision_info = move_and_collide(velocity * delta, false, collision_margin)
	if collision_info:
		print("Asteroid collided with ", collision_info.get_collider().name)
		print("Collision Depth: ", collision_info.get_depth())
		velocity = velocity.bounce(collision_info.get_normal())
		#ball_bounce.emit()
		#destroyed.emit() #emits signal
		queue_free()

#func damage(explosion):
	#health -= explosion.explosion_damage
	#if health <= 0:
			#get_parent().queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_destroyed(delta) -> void:
	print("Asteroid destroyed")
	velocity = $"../Ball/Ball".velocity
	var collision_info = move_and_collide(velocity * delta, false, collision_margin)
	velocity = velocity.bounce(collision_info.get_normal())
	queue_free()


func _on_body_entered(body: Node) -> void:
	print("Asteroid body entered")

	queue_free()
