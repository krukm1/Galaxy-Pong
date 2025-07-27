extends StaticBody2D

signal block_destroyed

@onready var sprite := $CollisionShape2D/Sprite2D  # Or adjust this path to match your scene

static var destroyed_count := 0  # Shared across all block instances

func _ready():
	add_to_group("Block")

func _on_destroyed():
	destroyed_count += 1
	print("Blocks destroyed: ", destroyed_count)
	emit_signal("block_destroyed")
	queue_free()  # free the block
