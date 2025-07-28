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
	var input_direction := Input.get_axis("ui_right", "ui_left")  # Read input for clockwise/counterclockwise rotation
	# var vertical_input := Input.get_axis("ui_up", "ui_down")  # (Optional: for radius control, currently unused)

# Check if Shift is held -> apply speed multiplier for paddle
	var is_shift_pressed := Input.is_action_pressed("ui_shift")
	var current_rotation_speed = ROTATION_SPEED
	if is_shift_pressed:
		current_rotation_speed *= 2.5  # Or any multiplier you want

	# If input is pressed, update the angle based on rotation speed
	if input_direction != 0:
		angle += input_direction * current_rotation_speed * delta
		angle = fmod(angle, TAU)  # Wrap the angle so it stays within 0 to 2π

	# Calculate the paddle’s position along the circular path using angle and radius
	global_position = center + Vector2(cos(angle), sin(angle)) * radius

	# Make the paddle face toward the centerpoint...
	look_at(center)
	# ...then rotate 90° clockwise so it's upright (perpendicular to its orbit direction)
	rotation += PI / 2
