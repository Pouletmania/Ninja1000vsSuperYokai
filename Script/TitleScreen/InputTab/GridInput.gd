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

#----------				----------#
#	Ready + fonctions associés
#----------				----------#

func _ready():
	InputManager.switch_configuration.connect(_on_switch_configuration)
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
		get_child(children).find_child("Label").focus_neighbor_right = get_child((children + 1) % get_child_count()).find_child("Label").get_path()
		get_child(children).find_child("Label").focus_neighbor_left = get_child((children - 1) % get_child_count()).find_child("Label").get_path()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de changement de controler
func _on_switch_configuration():
	rebuild_grid()

func rebuild_grid():
	clear_grid()
	build_grid()

func clear_grid():
	for children in get_children():
		remove_child(children)





