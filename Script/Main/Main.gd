extends Node


var Scene = load("res://Scene/TitleScreen/TitleScreen.tscn")
var Instance

func _ready():
	load_input_config()
	Instance = Scene.instantiate()
	add_child(Instance)

func load_input_config():
	var config = ConfigFile.new()
	config.load("res://Config/ConfigFiles.cfg")
	for action in config.get_section_keys("Input"):
		var event = InputEventKey.new()
		event.keycode = config.get_value("Input", action)
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
