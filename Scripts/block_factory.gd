extends Node2D

@export var breakable_block: PackedScene = preload("res://Scenes/breakable_block.tscn")


func _unhandled_input(event):
	if event.is_echo():
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			spawn(get_global_mouse_position())


func spawn(spawn_global_position):
	var block_instance = breakable_block.instantiate()
	block_instance.global_position = spawn_global_position
	add_child(block_instance)
	print(get_global_mouse_position())
