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
var LastFocus = 0		#Sauvegarde du dernier focus
var IsConfigLoad = false

#----------				----------#
#	Ready + fonctions associés
#----------				----------#

func _ready():
	InputManager.switch_configuration.connect(_on_switch_configuration)
	InputManager.inputmap_change.connect(_on_inputmap_change)
	build_grid()

#Création de la liste des inputs dans l'InputMap
func build_grid():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):	#Suppression des ui_input godot
			add_action_combo(action)
	build_neighbor()

#Création du menu de l'action
func add_action_combo(action: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action)
	add_child(actionCombo)

#Création des voisin pour la navication à l'aide des action ui_input de godot
func build_neighbor():
	for children in get_child_count():
		get_child(children).find_child("Label").focus_neighbor_right = get_child(find_right_neighbor(children)).find_child("Label").get_path()
		get_child(children).find_child("Label").focus_neighbor_left = get_child(find_left_neighbor(children)).find_child("Label").get_path()

#Fonction mathématique de recherche de voisin
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

#Setup du focus seulement à l'affichage
func _draw():
	if not IsConfigLoad:
		setup_focus()
	IsConfigLoad = false

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
	LastFocus = 0	#Réinitialisation du dernier focus au début de la grille
	rebuild_grid()

func rebuild_grid():
	clear_grid()
	build_grid()

func clear_grid():
	for children in get_children():
		remove_child(children)

#Appelé lors d'un changement de l'inputmap
func _on_inputmap_change(action: String):
	LastFocus = get_node(action).get_index()	#Enregistrement du dernier focus
	rebuild_grid()


