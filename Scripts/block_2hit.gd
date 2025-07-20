extends StaticBody2D

@export var block_velocity:= Vector2(0,0) # How fast the block will move.
@export var collision_margin = 0.08
var hit_count := 0  # Number of times the block has been hit
const MAX_HITS := 2  # Hits required to destroy the block

@onready var sprite_2d: Sprite2D = $CollisionShape2D/Sprite2D
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(block_velocity * delta, false, collision_margin, true)
	
	if collision_info and collision_info.get_collider().name != "player_character":
		hit_count += 1
		if hit_count >= MAX_HITS:
			Music_Controller.play_block_break()
			queue_free()
		else:
			# ✅ Change sprite color to white on first hit
			sprite_2d.modulate = Color("#ffffff")
			Music_Controller.play_block_break()  # Sound it when on first hit
