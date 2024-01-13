extends HBoxContainer

var IsListening: bool

func _ready():
	pass

func _process(delta):
	pass

# Should be called after is creation for clarity
func rename(action: String):
	self.name = action
	get_node("Label").text = action
	get_node("Input").text = InputMap.action_get_events(action)[0].as_text()

# Called each time a keyboard's key is pressed and process_input is set to true
func _input(event: InputEvent):
	if event is InputEventKey and IsListening:
		get_node("Input").text = event.as_text()
		listen_input(false)

# Called on click on child button "Label"
func _on_label_pressed():
	listen_input(true)

# Initialisation of listening process
func listen_input(value: bool):
	IsListening = value
	set_process_input(value)
	disabled_all_button(value)

# Disable all button in order to avoid multiple instance of listening process
func disabled_all_button(value: bool):
	for i in get_parent().get_child_count():
		get_parent().get_child(i).get_child(0).set_disabled(value)
