extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_pressed():
	get_node("MainMenu").visible = false
	get_node("OptionMenu").visible = true


func _on_back_pressed():
	get_node("MainMenu").visible = true
	get_node("OptionMenu").visible = false
