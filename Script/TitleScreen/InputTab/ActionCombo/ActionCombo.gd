extends HBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché à un ActionCombo permetant la gestion d'une configuration d'un
#input.

#---------------#
#	Variable
#---------------#

var Listener = preload("res://Scene/TitleScreen/ListeningKey.tscn").instantiate()

#-------		--------#
#	Chemin node enfant
#-------		--------#
var c_Label
var c_InputImg
var c_InputText

func setup_child_node_variable():
	c_Label  = get_node("Label")
	c_InputImg = get_node("InputImg")
	c_InputText = get_node("InputText")

#----------								----------#
#	Fonction Ready + fonctions associés
#----------								----------#

func _ready():
	setup_child_node_variable()

#----------									----------#
#	Initialisation (rename) + fonctions associés
#----------									----------#
#La fonction rename doit être appelé par le node parent
#après l'instantiation du node ActionCombo afin de procéder
#à son initialisation

func rename(action: String):
	self.name = action
	c_Label.text = action
	if not InputMap.action_get_events(action).is_empty():
		setup_input(InputMap.action_get_events(action)[0])

func setup_input(event):
	if InputManager.is_key_config_mode():
		setup_input_text(event)
	else:
		setup_input_image(event)

func setup_input_image(event):
	c_InputImg.load_image(event)
	toggle_to_text_input(false)

func setup_input_text(event):
	c_InputText.text = InputManager.convert_event_as_text(event)
	toggle_to_text_input(true)

func toggle_to_text_input(config: bool):
	c_InputText.visible = config
	c_InputImg.visible = !config

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Lance la reconfiguration de l'input via un listener
func _on_label_pressed():
	start_listening_input(self.name)

#Clear focus sur le bouton (Evite que l'input écouté soit interprété via le gui)
#Creation listener + attachement au root node pour centralisation d'affichage
#Lancement de l'écoute
#Libébration de l'instance
func start_listening_input(action: String):
	InputManager.clear_all_focus()
	get_tree().root.add_child(Listener)
	await Listener.listen(action)
	Listener.queue_free()
