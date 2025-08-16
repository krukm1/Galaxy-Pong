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
	var input_direction := Input.get_axis("ui_right", "ui_left")

	var is_shift_pressed := Input.is_action_pressed("ui_shift")
	var current_rotation_speed = ROTATION_SPEED
	if is_shift_pressed:
		current_rotation_speed *= 2.5

	if input_direction != 0:
		# Compute *candidate* new angle and position
		var new_angle = angle + input_direction * current_rotation_speed * delta
		var desired_position = center + Vector2(cos(new_angle), sin(new_angle)) * radius
		var motion = desired_position - global_position

		# Try the move
		var collision = move_and_collide(motion)
		if not collision:
			# Only commit if no collision
			angle = fmod(new_angle, TAU)
			global_position = desired_position   # 👈 actually move the paddle

	# Face the centerpoint
	look_at(center)
	rotation += PI / 2
