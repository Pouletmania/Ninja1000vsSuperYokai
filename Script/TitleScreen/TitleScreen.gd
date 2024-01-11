extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MainScreen").visible = true
	get_node("OptionScreen").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_pressed():
	get_node("MainScreen").visible = false
	get_node("OptionScreen").visible = true


func _on_back_pressed():
	get_node("MainScreen").visible = true
	get_node("OptionScreen").visible = false


func _on_quit_pressed():
	get_tree().quit()
