extends CharacterBody2D

signal hit

const ROTATION_SPEED = 3  # Radians per second
const RADIUS_CHANGE_SPEED = 200.0  # Units per second
const MIN_RADIUS = 150.0
const MAX_RADIUS = 300.0

@export var radius: float = 300.0
@export var MAX_HEALTH : int = 100
@export var health: int
var angle: float = 0.0
var center: Vector2



func _ready() -> void:
	center = get_viewport().get_camera_2d().get_screen_center_position()
	angle = PI / 2  # Start at the bottom of the screen
	
	health = MAX_HEALTH #Resets health to max


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_axis("ui_right", "ui_left")
	var vertical_input := Input.get_axis("ui_up", "ui_down")
	
	# Rotate angle based on horizontal input
	if input_direction != 0:
		angle += input_direction * ROTATION_SPEED * delta
		angle = fmod(angle, TAU)
	
	# Change radius based on vertical input
	if vertical_input != 0:
		radius += vertical_input * RADIUS_CHANGE_SPEED * delta
		radius = clamp(radius, MIN_RADIUS, MAX_RADIUS)
	
	# Update position based on angle and radius
	global_position = center + Vector2(cos(angle), sin(angle)) * radius
	#print("Global position is: ", global_position)
	# Face the center, then rotate 90 degrees clockwise to stand upright
	look_at(center)
	rotation += PI / 2
	
	
	var collision_info = move_and_collide(velocity*delta,false,0.05)
	if collision_info:
		if  collision_info.get_collider().is_in_group("asteroid"):
			health -= 10
			hit.emit()
			print("You were hit by an asteroid! Your Health dropped to ", health)
			collision_info.get_collider().queue_free()
		#else:
			#print("I collided with ", collision_info.get_collider().name)
		
		
	#if collision_info and collision_info.get_collider().name != "player_character":
			#health -= 10
			#print("You were hit by an asteroid! Your Health dropped to ", health)
			#collision_info.get_collider().queue_free()
	
