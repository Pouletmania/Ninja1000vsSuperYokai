extends GridContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node GridInput permetant la génération automatique des options
#de configuration des inputs du jeu.

#---------------#
#	Variable
#---------------#

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")
var LastFocus = 0
var JustLoad = false

#----------				----------#
#	Ready + fonctions associés
#----------				----------#

func _ready():
	InputManager.switch_configuration.connect(_on_switch_configuration)
	InputManager.inputmap_change.connect(_on_inputmap_change)
	build_grid()

func build_grid():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			add_action_combo(action)
	build_neighbor()

func add_action_combo(action: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action)
	add_child(actionCombo)

func build_neighbor():
	for children in get_child_count():
		get_child(children).find_child("Label").focus_neighbor_right = get_child(find_right_neighbor(children)).find_child("Label").get_path()
		get_child(children).find_child("Label").focus_neighbor_left = get_child(find_left_neighbor(children)).find_child("Label").get_path()

func find_left_neighbor(place: int):
	if place == 0:
		return (get_columns() - 1)
	else:
		return (((place - 1) % get_columns()))+floori(place / get_columns()) * get_columns()

func find_right_neighbor(place: int):
	return (((place + 1) % get_columns()))+floori(place / get_columns()) * get_columns()

#----------				----------#
#	Draw + fonctions associés
#----------				----------#

func _draw():
	rebuild_grid()
	if not JustLoad:
		setup_focus()
	JustLoad = false

func setup_focus():
	if not InputManager.is_key_config_mode():
		await get_tree().create_timer(0.2).timeout
		get_child(LastFocus).get_node("Label").grab_focus()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de changement de controler
func _on_switch_configuration():
	if is_visible_in_tree():
		rebuild_grid()

func rebuild_grid():
	clear_grid()
	build_grid()

func clear_grid():
	for children in get_children():
		remove_child(children)

func _on_inputmap_change(action: String):
	InputManager.clear_all_focus()
	LastFocus = get_node(action).get_index()
	rebuild_grid()

#Appelé lors de l'appuie sur le bouton Save
func _on_save_button_up():
	InputManager.load_last_config()
	update_current_config()
	InputManager.CurrentConfig.save(InputManager.ConfigPath)

func update_current_config():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			if not InputMap.action_get_events(action).is_empty():
				InputManager.CurrentConfig.set_value("Input", action, InputManager.format_event_for_config_files(InputMap.action_get_events(action)[0]))
			else:
				InputManager.CurrentConfig.set_value("Input", action, InputManager.format_event_for_config_files(null))

#Appelé lors de l'appuie sur le bouton Load
# - Load in buffer
# - Write in current inputmap
# - rebuild grid
func _on_load_button_up():
	JustLoad = true
	InputManager.load_last_config()
	InputManager.write_current_config_in_inputmap()
	rebuild_grid()
