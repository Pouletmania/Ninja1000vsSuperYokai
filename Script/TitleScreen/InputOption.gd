extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			var label = Label.new()
			var input = Label.new()
			label.text = action
			input.text = InputMap.action_get_events(action)[0].as_text()
			add_child(label)
			add_child(input)
			print(action)
			print(InputMap.action_get_events(action)[0].keycode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_key_name(action: String):
	# Gets the first input event attached to an action.
	var event = InputMap.action_get_events(action)[0]
	
	#TODO : Check if the event can be convert as text
	# if not, have to take associated picture (Exemple : A button on a GamePad)
	
	# Gets the constant scancode and the physical scancode of the key
	var scancode: int = event.scancode
	var physical_scancode: int = event.physical_scancode
	
	
	# Returns the name of the key
	return OS.get_keycode_string(event.keycode)
