extends RigidBody2D

@export var launch_speed: float = 400.0
@export var offset_distance: float = 40.0

var is_attached := true
var paddle: Node2D = null

func _ready():
	# Search for the paddle node in the scene tree
	paddle = get_parent().get_node_or_null("test_paddle")
	if paddle == null:
		print("Could not find paddle.")
	freeze = true  # Prevent physics until launch

func _process(delta):
	if is_attached and paddle:
		global_position = paddle.global_position + Vector2(0, -offset_distance).rotated(paddle.rotation)

func _input(event):
	if event.is_action_pressed("ui_accept") and is_attached:
		is_attached = false
		freeze = false
		linear_velocity = Vector2(0, -launch_speed).rotated(paddle.rotation)
