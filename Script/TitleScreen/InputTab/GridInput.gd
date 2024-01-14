extends GridContainer

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")
var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if try_to_load_config_files() and Config.has_section_key("InputConfig", "AutoLoad"):
		build_grid(Config.get_value("InputConfig", "AutoLoad"))
	else:
		build_grid(false)

func build_grid(fromConfig: bool):
	if fromConfig:
		build_from_config()
	else:
		build_from_input_map()

func try_to_load_config_files():
	if load_current_config() != OK:
		return false
	else:
		return true

func load_current_config():
	return Config.load("res://Config/ConfigFiles.cfg")

func rebuild_grid(fromConfig: bool):
	clear_grid()
	build_grid(fromConfig)

func clear_grid():
	for children in get_children():
		remove_child(children)

func build_from_config():
	if check_input_config():
		for actionKey in Config.get_section_keys("Input"):
			if not Config.get_value("Input", actionKey).begins_with("ui_"):
				add_action_combo(actionKey, Config.get_value("Input", actionKey))

func check_input_config():
	check_config_to_inputmap()
	if check_inputmap_to_config():
		return true
	else:
		return false

func check_inputmap_to_config():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and not Config.has_section_key("Input", action):
			print("Warning ! Erreur fichier de configuration : action " + action + " manquante")
			print("Une nouvelle sauvegarde est nécessaire pour le bon fonctionnement du jeu")
			build_from_input_map()
			return false
	return true

func check_config_to_inputmap():
	for action in Config.get_section_keys("Input"):
		if not InputMap.has_action(action):
			Config.erase_section_key("Input", action)
			Config.save("res://Config/ConfigFiles.cfg")

func build_from_input_map():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			add_action_combo(action, InputMap.action_get_events(action)[0].as_text())

func add_action_combo(action: String, input: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action, input)
	add_child(actionCombo)
