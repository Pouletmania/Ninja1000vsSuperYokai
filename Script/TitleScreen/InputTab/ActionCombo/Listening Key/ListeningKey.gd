extends Node

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node ListeningKey
#Permet l'écoute de la prochaine input pour retourner l'evenement associé
#Stop le programme durant l'écoute de l'input.
#Utilisation depuis un node parant : 
# - Création de l'instance : 
# - Ajout de l'instance créé au node root : get_node("/root").add_child(instance)
# - Récupération de l'evenement : var event = await instance.listen(action)
# - Traitement de l'évènement récupéré
# - Libération de l'espace mémoire : queue_free()


#---------------#
#	Variable
#---------------#
var IsListening: bool		#Toggle en cours de lecteur
var ActionListen: String	#Action en cours de lecture
var EventCatch = null		#Rédupération de l'évènement lu
var ActionToReplace = ""	#Action à remplacé si evènement lu déjà associé

const TriggeredValue = 0.8	#Seuil de détection des inputs analogique

#-------		--------#
#	Chemin node enfant
#-------		--------#
var c_Texte
var c_ReplaceButton
var c_CancelButton

func setup_child_node_variable():
	c_Texte  = get_node("Texte")
	c_CancelButton = get_node("Menu/Cancel")
	c_ReplaceButton = get_node("Menu/Replace")

#----------								----------#
#	Fonction Ready + fonctions associés
#----------								----------#

func _ready():
	InputManager.switch_configuration.connect(_on_cancel_button_up)	#Cancel si changement de controler
	setup_child_node_variable()

#----------								----------#
#	Fonction d'écoute + fonctions associés
#----------								----------#
#la fonction listen commence l'écoute de l'input
# - Génération d'une popup indiquant que la lecture d'une input au joueur
# - Initilisation de l'écoute
# - Attente d'un input

func listen(action: String):
	setup_ui(action)
	start_listening()
	while IsListening:
		await get_tree().create_timer(0.2).timeout

#Pas de bouton Cancel avec une manette
func setup_ui(action: String):
	ActionListen = action
	c_Texte.text = "Press input for " + ActionListen
	if InputManager.is_key_config_mode():
		c_CancelButton.visible = true

func start_listening():
	get_tree().paused = true
	IsListening = true

func stop_listening():
	IsListening = false
	get_tree().paused = false

#----------							----------#
#	Fonction _input + fonctions associés
#----------							----------#

func _input(event: InputEvent):
	if event is InputEventJoypadMotion and not InputManager.is_key_config_mode():
		if is_triggered(event):
			catch_event(event)
	elif event is InputEventJoypadButton and not InputManager.is_key_config_mode():
		catch_event(event)
	elif event is InputEventKey and InputManager.is_key_config_mode():
		catch_event(event)

#Verification si dépassement du seuil pour les inputs analogique
func is_triggered(event: InputEventJoypadMotion):
	if abs(event.get_axis_value()) > abs(TriggeredValue):
		return true
	else:
		return false

func catch_event(event: InputEvent):
	set_process_input(false)				#Stop l'appel de la fonction _input
	get_viewport().set_input_as_handled()	#Stop la transimission de l'input aux autre nodes
	EventCatch = event						#Récupération de l'evenement
	process_event_catched()					#Traitement de l'evenement récupéré

#On vérifie si l'évènement n'est pas déjà associé a une action avant enregitrement
func process_event_catched():
	var action = InputManager.search_event_in_action(EventCatch)
	if action != "" and action != ActionListen:
		ask_to_replace(action)
	else:
		InputManager.save_event_in_action(EventCatch, ActionListen)
		stop_listening()

func ask_to_replace(action: String):
	ActionToReplace = action					#Récupération de l'action de l'action déjà utilisé pour écrasement si accepte
	c_Texte.text = "Déjà utilisé pour : " + action
	draw_replace_menu()

#Affichage du menu de remplacement
func draw_replace_menu():
	c_ReplaceButton.visible = true
	c_CancelButton.visible = true
	InputManager.clear_all_focus()
	await get_tree().create_timer(0.2).timeout	#Delai avant positionnement du focus suppression de l'appel à l'action ui_accept de manière involontaire
	c_ReplaceButton.grab_focus()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

func _on_cancel_button_up():
	set_process_input(false)
	InputManager.inputmap_change.emit(ActionListen)
	stop_listening()

func _on_replace_button_up():
	InputManager.erase_event_in_action(ActionToReplace)
	InputManager.save_event_in_action(EventCatch, ActionListen)
	stop_listening()
