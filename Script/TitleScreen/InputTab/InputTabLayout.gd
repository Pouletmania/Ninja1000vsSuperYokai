extends VBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node InputTabLayout permetant la génération automatique de
#l'onglet d'option des inputs.
#Est composé d'une grille GrdiInput permetant la conguration unitaire des inputs
#et d'un menu permetant l'acces au fichier de configuration (Load / Save)

#-------		--------#
#	Chemin node enfant
#-------		--------#
var c_Grid

func setup_child_node_variable():
	c_Grid  = get_node("ListInput/MargeGrid/GridInput")

#----------								----------#
#	Fonction Ready + fonctions associés
#----------								----------#

func _ready():
	setup_child_node_variable()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

func _draw():
	c_Grid.LastFocus = 0	#Réinitialisation du dernier focus de la grille lors d'un nouvelle affichage d'input tab

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
	InputManager.load_last_config()
	InputManager.write_current_config_in_inputmap()
	c_Grid.rebuild_grid()
	c_Grid.IsConfigLoad = true		#Garde le focus sur le bouton load
