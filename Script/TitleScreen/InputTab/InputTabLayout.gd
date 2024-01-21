extends VBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node InputTabLayout permetant la génération automatique de
#l'onglet d'option des inputs.
#Est composé d'une grille GrdiInput permetant la conguration unitaire des inputs
#et d'un menu permetant l'acces au fichier de configuration (Load / Save)

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

func _draw():
	get_node("ListInput/GridInput").LastFocus = 0	#Réinitialisation du dernier focus de la grille lors d'un nouvelle affichage d'input tab

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
	get_node("ListInput/GridInput").rebuild_grid()
	get_node("ListInput/GridInput").IsConfigLoad = true		#Garde le focus sur le bouton load
