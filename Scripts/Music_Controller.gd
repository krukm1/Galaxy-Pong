extends Node

var menu_music = load("res://Assets/Music/Developing_Dreams.mp3")
var level1_music = load("res://Assets/Music/Neutralize.mp3")
var level2_music = load("res://Assets/Music/Freelancer.mp3")
var level3_music = load("res://Assets/Music/Retrofuturism.mp3")
var level4_music = load("res://Assets/Music/Escape_Route.mp3")
var level5_music = load("res://Assets/Music/Retrofuturism.mp3")
var level6_music = load("res://Assets/Music/Retrofuturism.mp3")
var level7_music = load("res://Assets/Music/Retrofuturism.mp3")
var level8_music = load("res://Assets/Music/Retrofuturism.mp3")
var level9_music = load("res://Assets/Music/Retrofuturism.mp3")
var level10_music = load("res://Assets/Music/Late_Ignition.mp3")
var level_complete_music = load("res://Assets/Music/level_complete_sound.mp3")
var block_break = load("res://Assets/Sounds/block_break_sound.mp3")
var start_button = load("res://Assets/Sounds/start_button.mp3")
var exit_esc_button = load("res://Assets/Sounds/exit_esc_button.mp3")
var menu_forward_button = load("res://Assets/Sounds/button1.mp3")
var menu_back_button = load("res://Assets/Sounds/button2.mp3")
var button_hover = load("res://Assets/Sounds/button_hover.mp3")
var block_hit = load("res://Assets/Sounds/block_hit_sound.mp3")
var ball_lost = load("res://Assets/Sounds/ball_lost3.mp3")

func _ready():
	pass
	
#Note: Keep audio files in separate sections below if you want them to play at the same time.
	
#------Music------
func play_menu_music():
	if not $Music.playing or $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.play()

func play_level1_music():
	if not $Music.playing or $Music.stream != level1_music:
		$Music.stream = level1_music
		$Music.play()
		
func play_level2_music():
	if not $Music.playing or $Music.stream != level2_music:
		$Music.stream = level2_music
		$Music.play()
		
func play_level3_music():
	if not $Music.playing or $Music.stream != level3_music:
		$Music.stream = level3_music
		$Music.play()
		
func play_level4_music():
	if not $Music.playing or $Music.stream != level4_music:
		$Music.stream = level4_music
		$Music.play()
		
func play_level5_music():
	if not $Music.playing or $Music.stream != level5_music:
		$Music.stream = level5_music
		$Music.play()
		
func play_level6_music():
	if not $Music.playing or $Music.stream != level6_music:
		$Music.stream = level6_music
		$Music.play()
		
func play_level7_music():
	if not $Music.playing or $Music.stream != level7_music:
		$Music.stream = level7_music
		$Music.play()
		
func play_level8_music():
	if not $Music.playing or $Music.stream != level8_music:
		$Music.stream = level8_music
		$Music.play()
		
func play_level9_music():
	if not $Music.playing or $Music.stream != level9_music:
		$Music.stream = level9_music
		$Music.play()
		
func play_level10_music():
	if not $Music.playing or $Music.stream != level10_music:
		$Music.stream = level10_music
		$Music.play()
		
func play_level_complete_music():
	if not $Music.playing or $Music.stream != level_complete_music:
		$Music.stream = level_complete_music
		$Music.play()

#------SFXPlayer1------
func play_block_break():
		$SFXPlayer1.stream = block_break
		$SFXPlayer1.play()
		
func play_start_button():
		$SFXPlayer1.stream = start_button
		$SFXPlayer1.play()
		
func play_exit_esc_button():
		$SFXPlayer1.stream = exit_esc_button
		$SFXPlayer1.play()
		
func play_menu_forward_button():
		$SFXPlayer1.stream = menu_forward_button
		$SFXPlayer1.play()

func play_menu_back_button():
		$SFXPlayer1.stream = menu_back_button
		$SFXPlayer1.play()

#------SFXPlayer2------
func play_button_hover():
		$SFXPlayer2.stream = button_hover
		$SFXPlayer2.play()
		
func play_block_hit():
		$SFXPlayer2.stream = block_hit
		$SFXPlayer2.play()

func play_ball_lost():
		$SFXPlayer2.stream = ball_lost
		$SFXPlayer2.play()
