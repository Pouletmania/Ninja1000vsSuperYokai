extends GridContainer

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")
var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_current_config()
	build_grid()

func build_grid():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and Config.has_section_key("Input", action):
			var event = InputEventKey.new()
			event.keycode = Config.get_value("Input", action)
			add_action_combo(action, event.as_text_keycode())
		elif not action.begins_with("ui_"):
			add_action_combo(action, InputMap.action_get_events(action)[0].as_text())

func try_to_load_config_files():
	if load_current_config() != OK:
		return false
	else:
		return true

func load_current_config():
	return Config.load("res://Config/ConfigFiles.cfg")

func rebuild_grid(fromConfig: bool):
	clear_grid()
	build_grid()

func clear_grid():
	for children in get_children():
		remove_child(children)

func add_action_combo(action: String, input: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action, input)
	add_child(actionCombo)
