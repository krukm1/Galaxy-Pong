extends Node2D

#@export var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")


#func _unhandled_input(event):
	#if event.is_echo():
		#return
	#if event is InputEventMouseButton and event.is_pressed():
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#spawn(global_position)
			#print(global_position)
#
#
#func spawn(spawn_global_position):
	#var instance = ball_scene.instantiate()
	#instance.start = (spawn_global_position)
	#add_child(instance)
	#
	#var shot_direction = Vector2(1,0).rotated(get_parent().rotation)
	#print(shot_direction)
	#instance.direction = shot_direction
