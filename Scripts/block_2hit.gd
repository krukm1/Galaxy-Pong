extends StaticBody2D

@export var block_velocity := Vector2(0, 0)
@export var collision_margin := 0.08

var hit_count := 0
const MAX_HITS := 2

@onready var sprite_2d: Sprite2D = $CollisionShape2D/Sprite2D

signal block_destroyed

func _ready() -> void:
	add_to_group("Block")  # So ball can detect it
	add_to_group("FadeOnGameStart")
	add_to_group("FadeOnGameOver")
	pass

func _physics_process(delta: float) -> void:
	move_and_collide(block_velocity * delta, false, collision_margin, true)

# Called by the ball when hit
func register_hit() -> void:
	hit_count += 1

	if hit_count >= MAX_HITS:
		Music_Controller.play_block_break()
		_on_destroyed()  # emit signal and free
	else:
		Music_Controller.play_block_hit()
		sprite_2d.modulate = Color("#ffffff")  # Optional: visual cue for being hit once

func _on_destroyed():
	emit_signal("block_destroyed")
	queue_free()  # free the block
