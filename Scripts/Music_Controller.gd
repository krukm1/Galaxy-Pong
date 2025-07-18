extends Node

var menu_music = load("res://Assets/Music/Developing_Dreams.mp3")
var level1_music = load("res://Assets/Music/Neutralize.mp3")
var block_break = load("res://Assets/Sounds/block_break_sound.mp3")
var start_button = load("res://Assets/Sounds/start_button.mp3")
var exit_esc_button = load("res://Assets/Sounds/exit_esc_button.mp3")
var menu_forward_button = load("res://Assets/Sounds/button1.mp3")
var menu_back_button = load("res://Assets/Sounds/button2.mp3")
var button_hover = load("res://Assets/Sounds/button_hover.mp3")

func _ready():
	pass
	
#Use either $Music, #SFXPlayer, or #SFXPlayer2 so audio can play at the same time
func play_menu_music():
	if not $Music.playing or $Music.stream != menu_music:
		$Music.stream = menu_music
		$Music.play()

func play_level1_music():
	if not $Music.playing or $Music.stream != level1_music:
		$Music.stream = level1_music
		$Music.play()

func play_block_break():
		$SFXPlayer.stream = block_break
		$SFXPlayer.play()
		
func play_start_button():
		$SFXPlayer.stream = start_button
		$SFXPlayer.play()
		
func play_exit_esc_button():
		$SFXPlayer.stream = exit_esc_button
		$SFXPlayer.play()
		
func play_menu_forward_button():
		$SFXPlayer.stream = menu_forward_button
		$SFXPlayer.play()

func play_menu_back_button():
		$SFXPlayer.stream = menu_back_button
		$SFXPlayer.play()

#hover is using SFXPlayer2 becuase it wasn't playing at the same time as SFXPlayer
func play_button_hover():
		$SFXPlayer2.stream = button_hover
		$SFXPlayer2.play()
