extends HBoxContainer

var Scene = load("res://Scene/TitleScreen/ListeningKey.tscn")

func rename(action: String, input: String):
	self.name = action
	get_node("Label").text = action
	get_node("Input").text = input

func _on_label_pressed():
	start_listening_input(self.name)

func start_listening_input(action: String):
	var instance = Scene.instantiate()
	get_node("/root").add_child(instance)
	var event = InputEventKey.new()
	event.keycode = await instance.listen(action)
	if not event.keycode == KEY_NONE:
		get_node("Input").text = event.as_text_keycode()
	instance.queue_free()
