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

#Appelé lors de l'appuie sur le bouton Save
func _on_save_button_up():
	InputManager.load_last_config()
	update_current_config()
	InputManager.CurrentConfig.save(InputManager.ConfigPath)

func update_current_config():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			InputManager.CurrentConfig.set_value("Input", action, InputManager.format_event_for_config_files(InputMap.action_get_events(action)[0]))

#Appelé lors de l'appuie sur le bouton Load
# - Load in buffer
# - Write in current inputmap
# - rebuild grid
func _on_load_button_up():
	InputManager.load_last_config()
	InputManager.write_current_config_in_inputmap()
	get_node("GridInput").rebuild_grid()
