extends Node2D

@onready var paddle = $paddle  # or however you get your paddle node
@onready var game_controller = $GameController  # assuming GameController is a child node
@onready var tilemap_layer = $TileMapLayer

var destroyed_times: Array = []
var powerup_scene = preload("res://Scenes/add_ball_powerup.tscn")

func _ready() -> void:
	game_controller._fade_in_nodes()
	
