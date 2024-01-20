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
var EventCatch = null
var TriggeredValue = 0.8
var ActionToReplace = ""

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
	start_listening()
	while IsListening:
		await get_tree().create_timer(0.2).timeout

func setup_ui(action: String):
	ActionListen = action
	get_node("Texte").text = "Press input for " + ActionListen
	if InputManager.is_key_config_mode():
		get_node("Menu/Cancel").visible = true

func start_listening():
	get_tree().paused = true
	IsListening = true
	set_process_input(true)

func stop_listening():
	IsListening = false
	get_tree().paused = false

#----------							----------#
#	Fonction _input + fonctions associés
#----------							----------#
#Fonctionne appélé lors de la déctection des inputs.
#Par défaut, la fonction n'est pas active, il est nécessaire d'appeler la
#fonction set_process_input(bool) pour ques les évènement soit pris en compte

func _input(event: InputEvent):
	if event is InputEventKey and InputManager.is_key_config_mode():
		catch_event(event)
	elif event is InputEventJoypadButton and not InputManager.is_key_config_mode():
		catch_event(event)
	elif event is InputEventJoypadMotion and not InputManager.is_key_config_mode():
		if is_triggered(event):
			catch_event(event)

func catch_event(event: InputEvent):
	set_process_input(false)
	get_viewport().set_input_as_handled()
	EventCatch = event
	process_event_catched()

func process_event_catched():
	var action = InputManager.search_event_in_action(EventCatch)
	if action != "" and action != ActionListen:
		ask_to_replace(action)
	else:
		InputManager.save_event_in_action(EventCatch, ActionListen)
		stop_listening()

func ask_to_replace(action: String):
	ActionToReplace = action
	get_node("Texte").text = "Déjà utilisé pour : " + ActionToReplace
	draw_replace_menu()

func draw_replace_menu():
	get_node("Menu/Replace").visible = true
	get_node("Menu/Cancel").visible = true
	InputManager.clear_all_focus()
	await get_tree().create_timer(0.2).timeout
	get_node("Menu/Replace").grab_focus()

#Valeur élevé au carré pour comparaison de nombre positif
func is_triggered(event: InputEventJoypadMotion):
	if abs(event.get_axis_value()) > abs(TriggeredValue):
		return true
	else:
		return false

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de l'appuie sur le bouton Cancel lors de l'écoute
func _on_cancel_button_up():
	set_process_input(false)
	InputManager.inputmap_change.emit(ActionListen)
	stop_listening()

func _on_replace_button_up():
	InputManager.erase_event_in_action(ActionToReplace)
	InputManager.save_event_in_action(EventCatch, ActionListen)
	stop_listening()
