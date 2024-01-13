extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Switch from Main menu to Option menu
func _on_option_pressed():
	get_node("MainScreen").visible = false
	get_node("OptionScreen").visible = true

# Go back to Main menu
func _on_back_pressed():
	get_node("MainScreen").visible = true
	get_node("OptionScreen").visible = false

# Quit the game
func _on_quit_pressed():
	get_tree().quit()
