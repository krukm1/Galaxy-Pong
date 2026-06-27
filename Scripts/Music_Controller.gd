extends Node


var menu_music = load("res://Assets/Music/Developing_Dreams.mp3")
var pause_menu_music = load("res://Assets/Music/pause_menu.mp3")
var level1_music = load("res://Assets/Music/Neutralize.mp3")
var level2_music = load("res://Assets/Music/Freelancer.mp3")
var level3_music = load("res://Assets/Music/Retrofuturism.mp3")
var level4_music = load("res://Assets/Music/Drifted_Wind.mp3")
var level5_music = load("res://Assets/Music/Moon_Cheese_Burger.mp3")
var level6_music = load("res://Assets/Music/Welcome_Anarchy.mp3")
var level7_music = load("res://Assets/Music/The_Color_of_Happiness.mp3")
var level8_music = load("res://Assets/Music/Retrofuturism.mp3")
var level9_music = load("res://Assets/Music/Retrofuturism.mp3")
var level10_music = load("res://Assets/Music/Late_Ignition.mp3")
var level_complete_music = load("res://Assets/Music/level_complete_sound.mp3")
var game_over_music = load("res://Assets/Music/game_over2.mp3")
var game_credits_music = load("res://Assets/Music/walk_but_in_a_garden.mp3")
var block_break = load("res://Assets/Sounds/block_break_sound.mp3")
var start_button = load("res://Assets/Sounds/start_button.mp3")
var exit_esc_button = load("res://Assets/Sounds/exit_esc_button.mp3")
var menu_forward_button = load("res://Assets/Sounds/button1.mp3")
var menu_back_button = load("res://Assets/Sounds/button2.mp3")
var button_hover = load("res://Assets/Sounds/button_hover.mp3")
var block_hit = load("res://Assets/Sounds/block_hit_sound.mp3")
var ball_lost = load("res://Assets/Sounds/lost_ball1.mp3")
var block_indestructible = load("res://Assets/Sounds/block_indestructible.mp3")
var add_ball_powerup_spawned = load("res://Assets/Sounds/gain_ball.mp3")
var add_ball_powerup = load("res://Assets/Sounds/gain_ball2.mp3")

func _ready():
	pass

#Note: Keep audio files in separate sections below if you want them to play at the same time.

#------Music------
func pause_music():
	if $Music.playing:
		$Music.stream_paused = true

func resume_music():
	if $Music.stream_paused:
		$Music.stream_paused = false

func stop_music():
	$Music.stop()

func play_menu_music():
	if not $Music.playing or $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.volume_db = 2
		$Music.play()

func play_level1_music():
	if not $Music.playing or $Music.stream != level1_music:
		$Music.stream = level1_music
		$Music.volume_db = -5
		$Music.play()

func play_level2_music():
	if not $Music.playing or $Music.stream != level2_music:
		$Music.stream = level2_music
		$Music.volume_db = -5
		$Music.play()

func play_level3_music():
	if not $Music.playing or $Music.stream != level3_music:
		$Music.stream = level3_music
		$Music.volume_db = -5
		$Music.play()

func play_level4_music():
	if not $Music.playing or $Music.stream != level4_music:
		$Music.stream = level4_music
		$Music.volume_db = -5
		$Music.play()

func play_level5_music():
	if not $Music.playing or $Music.stream != level5_music:
		$Music.stream = level5_music
		$Music.volume_db = -5
		$Music.play()

func play_level6_music():
	if not $Music.playing or $Music.stream != level6_music:
		$Music.stream = level6_music
		$Music.volume_db = -5
		$Music.play()

func play_level7_music():
	if not $Music.playing or $Music.stream != level7_music:
		$Music.stream = level7_music
		$Music.volume_db = -5
		$Music.play()

func play_level8_music():
	if not $Music.playing or $Music.stream != level8_music:
		$Music.stream = level8_music
		$Music.volume_db = -5
		$Music.play()

func play_level9_music():
	if not $Music.playing or $Music.stream != level9_music:
		$Music.stream = level9_music
		$Music.volume_db = -5
		$Music.play()

func play_level10_music():
	if not $Music.playing or $Music.stream != level10_music:
		$Music.stream = level10_music
		$Music.volume_db = -5
		$Music.play()

func play_level_complete_music():
	if not $Music.playing or $Music.stream != level_complete_music:
		$Music.stream = level_complete_music
		$Music.volume_db = 0
		$Music.play()

func play_game_over_music():
	if not $Music.playing or $Music.stream != game_over_music:
		$Music.stream = game_over_music
		$Music.volume_db = 0
		$Music.play()

func play_game_credits_music():
	if not $Music.playing or $Music.stream != game_credits_music:
		$Music.stream = game_credits_music
		$Music.volume_db = 0
		$Music.play()

#------Music2------
func play_pause_menu_music():
	if not $Music2.playing or $Music2.stream != pause_menu_music:
		$Music2.stream = pause_menu_music
		$Music2.volume_db = 3
		$Music2.play()

#------SFXPlayer1------
func play_block_break():
		$SFXPlayer1.stream = block_break
		$SFXPlayer1.volume_db = 0
		$SFXPlayer1.play()

func play_start_button():
		$SFXPlayer1.stream = start_button
		$SFXPlayer1.volume_db = 0
		$SFXPlayer1.play()

func play_exit_esc_button():
		$SFXPlayer1.stream = exit_esc_button
		$SFXPlayer1.volume_db = 0
		$SFXPlayer1.play()

func play_menu_forward_button():
		$SFXPlayer1.stream = menu_forward_button
		$SFXPlayer1.volume_db = 0
		$SFXPlayer1.play()

func play_menu_back_button():
		$SFXPlayer1.stream = menu_back_button
		$SFXPlayer1.volume_db = 0
		$SFXPlayer1.play()

#------SFXPlayer2------
func play_button_hover():
		$SFXPlayer2.stream = button_hover
		$SFXPlayer2.volume_db = +1
		$SFXPlayer2.play()

func play_block_hit():
		$SFXPlayer2.stream = block_hit
		$SFXPlayer2.volume_db = -20
		$SFXPlayer2.play()

func play_ball_lost():
		$SFXPlayer2.stream = ball_lost
		$SFXPlayer2.volume_db = -25  # Lower volume by 10 decibels (you can adjust this value)
		$SFXPlayer2.play()

#------SFXPlayer3------
func play_block_indestructible():
		$SFXPlayer3.stream = block_indestructible
		$SFXPlayer3.volume_db = -30  # Lower volume by 10 decibels (you can adjust this value)
		$SFXPlayer3.play()

func play_add_ball_powerup_spawned():
		$SFXPlayer3.stream = add_ball_powerup_spawned
		$SFXPlayer3.volume_db = -30  # Lower volume by 10 decibels (you can adjust this value)
		$SFXPlayer3.play()

func play_add_ball_powerup():
		$SFXPlayer3.stream = add_ball_powerup
		$SFXPlayer3.volume_db = -30  # Lower volume by 10 decibels (you can adjust this value)
		$SFXPlayer3.play()
