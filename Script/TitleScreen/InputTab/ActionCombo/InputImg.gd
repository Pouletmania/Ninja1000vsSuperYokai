extends TextureRect

func load_image(event):
	self.texture = load("res://Asset/GamepadInput/" + InputManager.convert_event_as_text(event) + ".png")
