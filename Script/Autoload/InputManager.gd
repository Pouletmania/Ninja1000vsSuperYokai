extends Node

const KeyboardConfigFiles = "res://Config/KeyboardConfigFiles.cfg"
const GamepadConfigFiles = "res://Config/GamepadConfigFiles.cfg"

var ConfigPath = ""
var KeyConfigMode
var CurrentConfig = ConfigFile.new()

signal switch_configuration

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	setup_first_config_input()

func setup_first_config_input():
	determine_config_path()
	load_last_config()
	write_current_config_in_inputmap()

func determine_config_path():
	if is_gamepad_connected():
		ConfigPath = GamepadConfigFiles
		KeyConfigMode = false
	else:
		ConfigPath = KeyboardConfigFiles
		KeyConfigMode = true

func load_last_config():
	CurrentConfig.load(InputManager.ConfigPath)

func write_current_config_in_inputmap():
	for action in CurrentConfig.get_section_keys("Input"):
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, convert_config_as_event(action))

func is_gamepad_connected():
	if Input.get_connected_joypads().size() > 0:
		return true
	else:
		return false

func _on_joy_connection_changed(device: int, connected: bool):
	if is_gamepad_connected() and is_key_config_mode():
		switch_config(GamepadConfigFiles)
	elif not is_gamepad_connected() and not is_key_config_mode():
		switch_config(KeyboardConfigFiles)

func switch_config(mode: String):
	ConfigPath = mode
	KeyConfigMode = !KeyConfigMode
	load_last_config()
	write_current_config_in_inputmap()
	switch_configuration.emit()

func convert_event_as_text(event):
	if event is InputEventKey:
		return event.as_text_keycode()
	elif event is InputEventJoypadButton:
		return str(event.get_button_index())
	elif event is InputEventJoypadMotion:
		return "TODO Convert Input Event Joypad Motion"

func convert_config_as_event(action):
	if is_key_config_mode():
		var event = InputEventKey.new()
		event.keycode = CurrentConfig.get_value("Input", action)
		return event
	else:
		if typeof(CurrentConfig.get_value("Input", action)) == TYPE_INT :
			var event = InputEventJoypadButton.new()
			event.set_button_index(int(CurrentConfig.get_value("Input", action)))
			return event
		else:
			#TODO Creat Input Event Joypad Motion
			var event = InputEventJoypadMotion.new()
			return event


func format_event_for_config_files(event):
	if event is InputEventKey:
		return event.keycode
	elif event is InputEventJoypadButton:
		return event.get_button_index()
	elif event is InputEventJoypadMotion:
		return "TODO Convert Input Event Joypad Motion"

func is_key_config_mode():
	return KeyConfigMode
