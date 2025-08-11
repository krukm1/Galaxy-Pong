extends Node2D

@onready var paddle = $paddle  # or however you get your paddle node
@onready var game_controller = $GameController  # assuming GameController is a child node
@onready var tilemap_layer = $TileMapLayer

var destroyed_times: Array = []
var powerup_scene = preload("res://Scenes/add_ball_powerup.tscn")

func _ready() -> void:
	game_controller.spawn_ball()
	game_controller._fade_in_nodes()
	await get_tree().create_timer(4.0).timeout
	_fade_loop()  # Start the fade animation loop
	
func _fade_loop() -> void:
	while true:
		if GameState.is_game_over:
			break

		# Fade out
		if not GameState.is_game_over:
			await _fade_tilemap(1.0, 0.0, 1.0)
		if GameState.is_game_over:
			break
		await get_tree().create_timer(5.0).timeout

		# Fade in
		if not GameState.is_game_over:
			await _fade_tilemap(0.0, 1.0, 1.0)
		if GameState.is_game_over:
			break
		await get_tree().create_timer(5.0).timeout

func _fade_tilemap(from_alpha: float, to_alpha: float, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(tilemap_layer, "modulate:a", to_alpha, duration).from(from_alpha)
	await tween.finished
