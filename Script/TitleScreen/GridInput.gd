extends GridContainer

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")
var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if try_to_load_config_files():
		construct_grid(Config.get_value("InputConfig", "AutoLoad"))
	else:
		load_from_input_map()

# Creation process of a combo "Action / Input"
func add_action_combo(action: String, input: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action, input)
	add_child(actionCombo)

func load_from_input_map():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			add_action_combo(action, InputMap.action_get_events(action)[0].as_text())

func load_from_config():
	for actionKey in Config.get_section_keys("Input"):
		if not Config.get_value("Input", actionKey).begins_with("ui_"):
			add_action_combo(actionKey, Config.get_value("Input", actionKey))

func clear_grid():
	for children in get_children():
		remove_child(children)

func construct_grid(fromConfig: bool):
	clear_grid()
	if fromConfig and try_to_load_config_files():
		load_from_config()
	else:
		load_from_input_map()

func try_to_load_config_files():
	var err = Config.load("res://Config/ConfigFiles.cfg")
	if err != OK:
		return false
	else:
		return true
