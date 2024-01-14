extends Node

var IsListening: bool
var ActionListen: String

func _input(event: InputEvent):
	if event is InputEventKey:
		InputMap.action_erase_events(ActionListen)
		InputMap.action_add_event(ActionListen, event)
		switch_listening(false)

func listen(action: String):
	setup_ui(action)
	switch_listening(true)
	while IsListening:
		await get_tree().create_timer(0.2).timeout
	return InputMap.action_get_events(action)

func setup_ui(action: String):
	ActionListen = action
	get_node("Texte").text = "Press input for " + action

func switch_listening(value: bool):
	get_tree().paused = value
	IsListening = value
	set_process_input(value)

func _on_cancel_button_down():
	switch_listening(false)
	
