extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_key_name(action: String):
	# Gets the first input event attached to an action.
	var event = InputMap.action_get_events(action)[0]
	
	#TODO : Check if the event can be convert as text
	# if not, have to take associated picture (Exemple : A button on a GamePad)
	
	# Return the event as text.In
	return event.as_text()
