extends Node2D

@export var block: PackedScene = preload("res://Scenes/block.tscn")

func _unhandled_input(event):
	if event.is_echo():
		return
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			spawn(get_global_mouse_position())
	
	if Input.is_action_pressed("E Key"):
		spawn(get_global_mouse_position())

func spawn(spawn_global_position):
	var instance = block.instantiate()
	instance.global_position = spawn_global_position
	add_child(instance)
