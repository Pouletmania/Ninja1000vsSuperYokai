extends Node

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node autoload InputManager servant a la gestion des
#input du jeu. 
# - Permet la convertion des evenement sous différent format et inversement.
# - Gère la détection automatique d'un gamepad + modification de configuration
#associé 

#---------------#
#	Variable
#---------------#

#Chemin des fichiers de configuration en fonction du controleur utilisé
const KeyboardConfigFiles = "res://Config/KeyboardConfigFiles.cfg"
const GamepadConfigFiles = "res://Config/GamepadConfigFiles.cfg"

#Variable de gestion de la configuration acutellement utilisé
var ConfigPath = ""
var KeyConfigMode: bool
var CurrentConfig = ConfigFile.new()

#Signal émit lors d'un changement de configuration.
signal switch_configuration
signal inputmap_change

#------------#
#	Getter
#------------#

func is_key_config_mode():
	return KeyConfigMode


#----------				----------#
#	Ready + fonctions associés
#----------				----------#

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	setup_first_config_input()

func setup_first_config_input():
	determine_config()
	load_last_config()
	write_current_config_in_inputmap()

func determine_config():
	if is_gamepad_connected():
		set_joypad_mode()
	else:
		set_keyboad_mode()

func is_gamepad_connected():
	if Input.get_connected_joypads().size() > 0:
		return true
	else:
		return false

func set_joypad_mode():
	ConfigPath = GamepadConfigFiles
	KeyConfigMode = false

func set_keyboad_mode():
	ConfigPath = KeyboardConfigFiles
	KeyConfigMode = true
	clear_all_focus()

func clear_all_focus():
	var temp = Control.new()
	add_child(temp)
	temp.set_focus_mode(Control.FOCUS_ALL)
	temp.grab_focus()
	temp.release_focus()
	temp.queue_free()

func load_last_config():
	CurrentConfig.load(InputManager.ConfigPath)

func write_current_config_in_inputmap():
	for action in CurrentConfig.get_section_keys("Input"):
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
			if convert_config_as_event(action) != null:
				InputMap.action_add_event(action, convert_config_as_event(action))

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

func _on_joy_connection_changed(device: int, connected: bool):
	if is_gamepad_connected() and is_key_config_mode():
		switch_config()
	elif not is_gamepad_connected() and not is_key_config_mode():
		switch_config()

func switch_config():
	setup_first_config_input()
	switch_configuration.emit()

#----------													----------#
#	Fonction de manipulation de l'InputMap + fonctions associés
#----------													----------#

#Retourne l'action associé à un évènement, retourne une chaine vide si aucune action trouvé
func search_event_in_action(event: InputEvent):
	for action in InputMap.get_actions():
		if InputMap.action_has_event(action, event) and not action.begins_with("ui_"):
			return action
	return ""

func save_event_in_action(event: InputEvent, action: String):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	inputmap_change.emit(action)

func erase_event_in_action(action: String):
	InputMap.action_erase_events(action)

#----------								----------#
#	Fonction de convertion + fonctions associés
#----------								----------#

func convert_event_as_text(event: InputEvent):
	if event is InputEventKey:
		return event.as_text_keycode()
	elif event is InputEventJoypadButton:
		return str(event.get_button_index())
	elif event is InputEventJoypadMotion:
		return str(event.get_axis()) + determine_direction(event)

func determine_direction(event: InputEvent):
	if event.get_axis_value() > 0:
		return "Plus"
	else:
		return "Minus"

func format_event_for_config_files(event: InputEvent):
	if event is InputEventKey:
		return event.keycode
	elif event is InputEventJoypadButton:
		return event.get_button_index()
	elif event is InputEventJoypadMotion:
		return str(event.get_axis()) + determine_direction(event)
	else:
		return "null"

func convert_config_as_event(action: String):
	if config_is_null(action):
		return null
	else:
		if is_key_config_mode():
			return create_InputEventKey_from_config(action)
		else:
			return create_joypad_event(action)

func config_is_null(action):
	if str(CurrentConfig.get_value("Input", action)) == "null":
		return true
	else:
		return false

func create_InputEventKey_from_config(action: String):
		var event = InputEventKey.new()
		event.keycode = CurrentConfig.get_value("Input", action)
		return event

func create_joypad_event(action: String):
	if typeof(CurrentConfig.get_value("Input", action)) == TYPE_INT :
		return create_InputEventJoypadButton_from_config(action)
	else:
		return create_InputEventJoypadMotion_from_config(action)

func create_InputEventJoypadButton_from_config(action: String):
	var event = InputEventJoypadButton.new()
	var index = int(CurrentConfig.get_value("Input", action))
	event.set_button_index(index)
	return event

func create_InputEventJoypadMotion_from_config(action: String):
	var event := InputEventJoypadMotion.new()
	event.axis = int(CurrentConfig.get_value("Input", action).left(1)) as JoyAxis
	event.axis_value = determine_axis_value(action)
	return event

func determine_axis_value(action: String):
	if CurrentConfig.get_value("Input", action).find("Plus") != -1:
		return 1
	else:
		return -1
