extends MarginContainer

func _on_option_pressed():
	get_node("MainScreen").visible = false
	get_node("OptionScreen").visible = true

func _on_back_pressed():
	get_node("MainScreen").visible = true
	get_node("OptionScreen").visible = false

func _on_quit_pressed():
	get_tree().quit()
