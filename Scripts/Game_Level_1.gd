extends Node2D

@onready var paddle = $paddle  # or however you get your paddle node
@onready var game_controller = $GameController  # assuming GameController is a child node
@onready var tilemap_layer = $TileMapLayer

var destroyed_times: Array = []
var powerup_scene = preload("res://Scenes/add_ball_powerup.tscn")

func _ready() -> void:
	game_controller.spawn_ball()
	_fade_in_nodes()

func _fade_in_nodes():
	for node in get_tree().get_nodes_in_group("FadeOnGameStart"):
		if node is CanvasItem:
			node.modulate.a = 0.0
			var tween := create_tween()
			tween.tween_property(node, "modulate:a", 1.0, 2)

func _fade_out_nodes():
	for node in get_tree().get_nodes_in_group("FadeOnGameOver"):
		if node is CanvasItem:
			var tween := create_tween()
			tween.tween_property(node, "modulate:a", 0.0, 6)
