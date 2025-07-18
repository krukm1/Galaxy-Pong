extends RigidBody2D

@export var velocity:= Vector2(0,0) # How fast the block will move.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info: # We only want to bounce if the ball actually collided.
		#velocity = velocity.bounce(collision_info.get_normal()) 
	pass
