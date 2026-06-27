extends StaticBody2D

func _ready():
	add_to_group("Block_Indestructible")
	add_to_group("FadeOnGameStart")
	add_to_group("FadeOnGameOver")
