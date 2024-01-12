extends HBoxContainer

var isListening = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_action(action: String):
	self.name = action
	get_node("Label").text = action
	get_node("Input").text = InputMap.action_get_events(action)[0].as_text()
	set_process_input(false)


func _input(event: InputEvent):
	# Handle the first pressed key
	if event is InputEventKey and isListening:
		get_node("Input").text = event.as_text()
		isListening = false
		set_process_input(false)
		for sister in get_parent().get_child_count():
			get_parent().get_child(sister).get_child(0).set_disabled(false)
		


func _on_label_pressed():
	print("Waiting for input : " + self.name)
	isListening = true
	set_process_input(true)
	for sister in get_parent().get_child_count():
		get_parent().get_child(sister).get_child(0).set_disabled(true)

func _on_label_pressed_action(action):
	print("Waiting for input : " + action)


