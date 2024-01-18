extends MarginContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node TitleScreen permetant la gestion des changements des
#différent menu de l'écran titre

func _ready():
	InputManager.switch_configuration.connect(_on_switch_configuration)

func _draw():
	if not InputManager.is_key_config_mode() and is_visible_in_tree():
		init_first_selection()
	else:
		release_focus()

func init_first_selection():
	get_node("MainScreen/Continue").grab_focus()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de l'appuie sur le bouton Option du menu principale
func _on_option_pressed():
	get_node("MainScreen").visible = false
	get_node("OptionScreen").visible = true

#Appelé lors de l'appuie sur le bouton Back de n'importe qu'elle menu enfant
func _on_back_pressed():
	get_node("MainScreen").visible = true
	get_node("OptionScreen").visible = false

#Appelé lors de l'appuie sur le bouton Quit
func _on_quit_pressed():
	get_tree().quit()

#Appelé lors de changement de configuration
func _on_switch_configuration():
	_draw()
