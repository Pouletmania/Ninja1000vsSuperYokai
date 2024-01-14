extends GridContainer

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")
var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if try_to_load_config_files():
		construct_grid(Config.get_value("InputConfig", "AutoLoad"))
	else:
		construct_from_input_map()

func try_to_load_config_files():
	var err = load_current_config()
	if err != OK:
		return false
	else:
		return true

func load_current_config():
	return Config.load("res://Config/ConfigFiles.cfg")

func construct_grid(fromConfig: bool):
	clear_grid()
	if fromConfig and try_to_load_config_files():
		construct_from_config()
	else:
		construct_from_input_map()

func clear_grid():
	for children in get_children():
		remove_child(children)

func construct_from_config():
	for actionKey in Config.get_section_keys("Input"):
		if not Config.get_value("Input", actionKey).begins_with("ui_"):
			add_action_combo(actionKey, Config.get_value("Input", actionKey))

func construct_from_input_map():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			add_action_combo(action, InputMap.action_get_events(action)[0].as_text())

func add_action_combo(action: String, input: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action, input)
	add_child(actionCombo)
