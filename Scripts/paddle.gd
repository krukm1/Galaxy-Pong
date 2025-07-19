extends CharacterBody2D

@onready var centerpoint: Node2D = $"../centerpoint"

const ROTATION_SPEED = 3  # Radians per second
const RADIUS_CHANGE_SPEED = 200.0  # Units per second
const MIN_RADIUS = 150.0
const MAX_RADIUS = 300.0

@export var radius: float = 300.0
var angle: float = 0.0
var center: Vector2

func _ready() -> void:
	var cp = get_parent().get_node("centerpoint")
	print("centerpoint position: ", cp.global_position)
	center = cp.global_position
	angle = PI / 2
	
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
