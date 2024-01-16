extends HBoxContainer

var Scene = load("res://Scene/TitleScreen/ListeningKey.tscn")

func rename(action: String):
	self.name = action
	get_node("Label").text = action
	setup_input(InputMap.action_get_events(action)[0])

func setup_input(event):
	if InputManager.is_key_config_mode():
		setup_input_text(event)
	else:
		setup_input_image(event)

func setup_input_image(event):
	get_node("InputImg").load_image(event)
	toggle_to_text_input(false)

func setup_input_text(event):
	get_node("InputText").text = InputManager.convert_event_as_text(event)
	toggle_to_text_input(true)

func toggle_to_text_input(config: bool):
	get_node("InputText").visible = config
	get_node("InputImg").visible = !config

func _on_label_pressed():
	start_listening_input(self.name)

func start_listening_input(action: String):
	var instance = Scene.instantiate()
	get_node("/root").add_child(instance)
	var event = await instance.listen(action)
	update_input_text(event)
	instance.queue_free()

func update_input_text(event):
	if not event == null:
		setup_input(event)
