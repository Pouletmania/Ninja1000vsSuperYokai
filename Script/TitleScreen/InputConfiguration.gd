extends HBoxContainer

var Scene = load("res://Scene/TitleScreen/ListeningKey.tscn")

func _ready():
	pass

func _process(delta):
	pass

# Should be called after is creation for clarity
func rename(action: String):
	self.name = action
	get_node("Label").text = action
	get_node("Input").text = InputMap.action_get_events(action)[0].as_text()

# Called on click on child button "Label"
func _on_label_pressed():
	start_listening_input(self.name)

func start_listening_input(action: String):
	var instance = Scene.instantiate()
	get_node("/root").add_child(instance)
	get_node("Input").text = await instance.listen(action)
	instance.queue_free()
	
