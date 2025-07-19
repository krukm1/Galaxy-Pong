extends CharacterBody2D

const ROTATION_SPEED = 3  # Radians per second
const RADIUS_CHANGE_SPEED = 200.0  # Units per second
const MIN_RADIUS = 150.0
const MAX_RADIUS = 300.0

@export var radius: float = 300.0
var angle: float = 0.0
var center: Vector2

func _ready() -> void:
	center = get_viewport().get_camera_2d().get_screen_center_position()
	angle = PI / 2  # Start at the bottom of the screen
	
func _physics_process(delta: float) -> void:
	var input_direction := Input.get_axis("ui_right", "ui_left")
#	var vertical_input := Input.get_axis("ui_up", "ui_down")
	
	# Rotate angle based on horizontal input
	if input_direction != 0:
		angle += input_direction * ROTATION_SPEED * delta
		angle = fmod(angle, TAU)
	
	# Update position based on angle and radius
	global_position = center + Vector2(cos(angle), sin(angle)) * radius
	
	# Face the center, then rotate 90 degrees clockwise to stand upright
	look_at(center)
	rotation += PI / 2
