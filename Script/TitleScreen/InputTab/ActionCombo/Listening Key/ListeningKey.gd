extends Node

var IsListening: bool
var ActionListen: String
var EventListen = null

func _input(event: InputEvent):
	if event is InputEventKey and InputManager.is_key_config_mode():
		save_and_stop(event)
	if (event is InputEventJoypadButton or event is InputEventJoypadMotion) and not InputManager.is_key_config_mode():
		save_and_stop(event)

func listen(action: String):
	setup_ui(action)
	switch_listening(true)
	while IsListening:
		await get_tree().create_timer(0.2).timeout
	return EventListen

func setup_ui(action: String):
	ActionListen = action
	get_node("Texte").text = "Press input for " + action

func switch_listening(value: bool):
	get_tree().paused = value
	IsListening = value
	set_process_input(value)

func _on_cancel_button_down():
	switch_listening(false)

func save_and_stop(event):
	EventListen = event
	InputMap.action_erase_events(ActionListen)
	InputMap.action_add_event(ActionListen, event)
	switch_listening(false)
