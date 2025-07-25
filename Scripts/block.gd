extends StaticBody2D

func _ready():
	add_to_group("Block")
	add_to_group("FadeOnGameStart")
	add_to_group("FadeOnGameOver")
