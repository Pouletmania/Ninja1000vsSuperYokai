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
var IsListening: bool
var ActionListen: String
var EventListen = null
var TriggeredValue = 0.8

#----------								----------#
#	Fonction d'écoute + fonctions associés
#----------								----------#
#la fonction listen commence l'écoute de l'input
# - Génération d'une popup indiquant que la lecture d'une input au joueur
# - Initilisation de l'écoute
# - Attente d'un input
# - Envoi de l'évènement écouté

func listen(action: String):
	setup_ui(action)
	toggle_listening(true)
	while IsListening:
		await get_tree().create_timer(0.2).timeout
	return EventListen

func setup_ui(action: String):
	ActionListen = action
	get_node("Texte").text = "Press input for " + action

#Début de l'écoute : 
# - Mise à jour de la pause du jeu
# - Mise à jour de la récupération des évènement input
func toggle_listening(value: bool):
	get_tree().paused = value
	IsListening = value
	set_process_input(value)

#----------							----------#
#	Fonction _input + fonctions associés
#----------							----------#
#Fonctionne appélé lors de la déctection des inputs.
#Par défaut, la fonction n'est pas active, il est nécessaire d'appeler la
#fonction set_process_input(bool) pour ques les évènement soit pris en compte

func _input(event: InputEvent):
	if event is InputEventKey and InputManager.is_key_config_mode():
		save_and_stop(event)
	elif event is InputEventJoypadButton and not InputManager.is_key_config_mode():
		save_and_stop(event)
	elif event is InputEventJoypadMotion and not InputManager.is_key_config_mode():
		if is_triggered(event):
			save_and_stop(event)

func save_and_stop(event):
	EventListen = event
	InputMap.action_erase_events(ActionListen)
	InputMap.action_add_event(ActionListen, event)
	toggle_listening(false)

#Valeur élevé au carré pour comparaison de nombre positif
func is_triggered(event):
	if abs(event.get_axis_value()) > abs(TriggeredValue):
		return true
	else:
		return false

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de l'appuie sur le bouton Cancel lors de l'écoute
func _on_cancel_button_down():
	toggle_listening(false)
