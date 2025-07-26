extends StaticBody2D

signal block_destroyed

func _ready():
	add_to_group("Block")
	add_to_group("FadeOnGameStart")
	add_to_group("FadeOnGameOver")

func _on_destroyed():
	print("Block destroyed!")
	emit_signal("block_destroyed")
	queue_free()  # free the block
