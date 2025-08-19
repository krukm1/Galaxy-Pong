extends CharacterBody2D

# --- Node reference ---
@onready var centerpoint: Node2D = $"../centerpoint"  # Reference to the centerpoint node, assumed to be a sibling

# --- Constants for movement and limits ---
const ROTATION_SPEED = 3  # Speed at which the paddle rotates (radians per second)
const RADIUS_CHANGE_SPEED = 200.0  # Optional: Speed at which radius could be changed (not used yet)
const MIN_RADIUS = 150.0  # Minimum allowed radius from center
const MAX_RADIUS = 300.0  # Maximum allowed radius from center

# --- State variables ---
@export var radius: float = 300.0  # Distance from the centerpoint (adjustable in editor)
var angle: float = 0.0  # Current angle around the center (in radians)
var center: Vector2  # World position of the centerpoint

# --- Called when the node enters the scene tree ---
func _ready() -> void:
	var cp = get_parent().get_node("centerpoint")  # Look up the centerpoint node
	print("centerpoint position: ", cp.global_position)  # Debug: print its position
	center = cp.global_position  # Store the centerpoint's world position
	angle = PI / 2  # Start at the bottom of the circle (facing up)
	add_to_group("FadeOnGameStart")
	add_to_group("FadeOnGameOver")
	add_to_group("Paddle")

# --- Called every physics frame ---
func _physics_process(delta: float) -> void:
	# Get input (-1 = left, +1 = right)
	var input_direction := Input.get_axis("ui_right", "ui_left")
	
	if input_direction == 0:
		return  # No movement, early exit
	
	# Optional: speed boost when Shift is pressed
	var current_rotation_speed = ROTATION_SPEED
	if Input.is_action_pressed("ui_shift"):
		current_rotation_speed *= 2.5
	
	# Update angle (wrap around 0..TAU for continuous spin)
	angle += input_direction * current_rotation_speed * delta
	angle = fmod(angle, TAU)
	
	# Compute new candidate position along the circle
	var desired_position = center + Vector2(cos(angle), sin(angle)) * radius
	
	# Move the paddle using move_and_collide to respect collisions
	var motion = desired_position - global_position
	var collision = move_and_collide(motion)
	
	if collision:
		# Optional: slide along wall if you want smoother contact
		var slide_motion = motion.slide(collision.get_normal())
		move_and_collide(slide_motion)
		# Angle correction: prevent sticking
		# Recompute angle from new global_position
		angle = atan2(global_position.y - center.y, global_position.x - center.x)
	
	# Face the centerpoint
	look_at(center)
	rotation += PI / 2
