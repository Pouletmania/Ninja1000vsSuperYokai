extends GridContainer

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")
var Config = ConfigFile.new()

func _ready():
	load_current_config()
	build_grid()

func build_grid():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and Config.has_section_key("Input", action):
			add_action_combo(action, get_input_as_text(action))
		elif not action.begins_with("ui_"):
			add_action_combo(action, InputMap.action_get_events(action)[0].as_text())
	build_neighbor()

func get_input_as_text(action: String):
	var event = InputEventKey.new()
	event.keycode = Config.get_value("Input", action)
	return event.as_text_keycode()

func load_current_config():
	Config.load(Files.Config)

func rebuild_grid():
	clear_grid()
	load_current_config()
	build_grid()

func clear_grid():
	for children in get_children():
		remove_child(children)

func add_action_combo(action: String, input: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action, input)
	add_child(actionCombo)

func build_neighbor():
	for children in get_child_count():
		get_child(children).find_child("Label").focus_neighbor_right = get_child((children + 1) % get_child_count()).find_child("Label").get_path()
		get_child(children).find_child("Label").focus_neighbor_left = get_child((children - 1) % get_child_count()).find_child("Label").get_path()
