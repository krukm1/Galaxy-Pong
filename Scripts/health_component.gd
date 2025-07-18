extends RigidBody2D

@export var MAX_HEALTH := 1.0
var health : float


func _ready() -> void:
	health = MAX_HEALTH
