extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Pauses game when ESC key is pressed. Doesn't work yet.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		show()


## When start button is pressed. Need to add pause/playing states.
func _on_button_pressed() -> void:
	hide()


## Options button doesn't do anything yet.
func _on_options_button_pressed() -> void:
	pass # Replace with function body.


## Exit button exits game
func _on_exit_button_pressed() -> void:
	get_tree().quit()
