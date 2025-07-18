extends Node

@export var asteroid_scene: PackedScene = preload("res://Scenes/asteroid.tscn")
@export var asteroid_damage = 10
var score
var health


func _ready() -> void:
	Music_Controller.play_level1_music()
	health = $new_paddle.health
	print("HP is ", health)
	new_game()


func game_over():
	if health <= 0:
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		print("GAME OVER")
		
	else:
		health -= asteroid_damage

func new_game():
	get_tree().call_group(&"asteroid", &"queue_free")
	score = 0
	health = 100
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_health(health)
	$HUD.show_message("Get Ready")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Music_Controller.play_exit_esc_button()
		get_tree().change_scene_to_file("res://Scenes/Title_Menu.tscn")


## Spawns Asteroids on asteroid_path
func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate() # Created new empty node named 'asteroid'
	var asteroid_spawn_location = get_node(^"asteroid_path/asteroid_spawn_location") # assigns spawn location to path2D_follow node
	var asteroid_direction = asteroid_spawn_location.rotation + PI/2
	var velocity = Vector2(randf_range(50.0, 150.0), 0.0) # Range of asteroid starting speed
	
	asteroid_spawn_location.progress = randi() # Selects a random point on path2D node
	asteroid.position = asteroid_spawn_location.position # Assigns path2D location to instantiated node position vector
	asteroid_direction += randf_range(-PI / 4, PI / 4)
	asteroid.rotation = asteroid_direction
	
	asteroid.linear_velocity = velocity.rotated(asteroid_direction)
	add_child(asteroid)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	#print("Asteroid Entered Scene!")

func _on_start_timer_timeout() -> void:
	$AsteroidTimer.start()
	$ScoreTimer.start()
	print("Start Timeout Triggered!")

func _on_damage_taken() -> void:
	$HUD.update_health(health)
	print("Health Updated on HUD")
