extends Node

var InputListen: String
var IsListening: bool
var ActionListen: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent):
	if event is InputEventKey:
		InputListen = event.as_text()
		switch_listening(false)

func listen(action: String):
	setup_ui(action)
	switch_listening(true)
	while IsListening:
		await get_tree().create_timer(0.2).timeout
	return InputListen

func setup_ui(action: String):
	ActionListen = action
	get_node("Texte").text = "Press input for " + action

func switch_listening(value: bool):
	get_tree().paused = value
	IsListening = value
	set_process_input(value)


func _on_cancel_button_down():
	InputListen = InputMap.action_get_events(ActionListen)[0].as_text()
	switch_listening(false)
	
