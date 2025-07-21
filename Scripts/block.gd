extends StaticBody2D

@export var block_velocity:= Vector2(0,0) # How fast the block will move.
@export var collision_margin = 0.08
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(block_velocity * delta, false, collision_margin, true)
	if collision_info and collision_info.get_collider().name != "player_character":
		Music_Controller.play_block_break()
		queue_free()
