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
var SetupFocus = true

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
	print(get_child_count())
	for children in get_child_count():
		print(children)
		get_child(children).find_child("Label").focus_neighbor_right = get_child(find_right_neighbor(children)).find_child("Label").get_path()
		get_child(children).find_child("Label").focus_neighbor_left = get_child(find_left_neighbor(children)).find_child("Label").get_path()

func find_left_neighbor(place: int):
	if place == 0:
		return (get_columns() - 1)
	else:
		return min((((place - 1) % get_columns()))+floori(place / get_columns()) * get_columns(),get_child_count()-1)

func find_right_neighbor(place: int):
	return min((((place + 1) % get_columns()))+floori(place / get_columns()) * get_columns(),get_child_count()-1)

#----------				----------#
#	Draw + fonctions associés
#----------				----------#

func _draw():
	rebuild_grid()
	if SetupFocus:
		setup_focus()
	SetupFocus = true

func rebuild_grid():
	clear_grid()
	build_grid()

func clear_grid():
	for children in get_children():
		remove_child(children)

#Setup le focus à au dernier focus sauvegardé
func setup_focus():
	if not InputManager.is_key_config_mode():
		#Attente de 0.2 avant setup focus pour ne pas prendre en compte l'input ui_accept trop rapidement
		await get_tree().create_timer(0.2).timeout
		get_child(LastFocus).get_node("Label").grab_focus()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de changement de controler
func _on_switch_configuration():
	if is_visible_in_tree():
		rebuild_grid()

#Appelé lors d'un changement de l'inputmap
func _on_inputmap_change(action: String):
	InputManager.clear_all_focus()
	LastFocus = get_node(action).get_index()
	rebuild_grid()

#Appelé lors de l'appuie sur le bouton Save
func _on_save_button_up():
	InputManager.load_last_config()
	InputManager.update_current_config()
	InputManager.save_current_inputmap()

#Appelé lors de l'appuie sur le bouton Load
# - Load in buffer
# - Write in current inputmap
# - rebuild grid
func _on_load_button_up():
	SetupFocus = false
	InputManager.load_last_config()
	InputManager.write_current_config_in_inputmap()
	rebuild_grid()
