extends StaticBody2D

func _ready():
	add_to_group("Block_Indestructible")  # ← Add block to group from code
	add_to_group("FadeOnGameOver")  # 👈 Add this line
