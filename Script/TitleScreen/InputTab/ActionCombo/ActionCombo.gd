extends HBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node autoload InputManager servant a la gestion des
#input du jeu. 
# - Permet la convertion des evenement sous différent format et inversement.
# - Gère la détection automatique d'un gamepad + modification de configuration
#associé 

#---------------#
#	Variable
#---------------#

var Scene = load("res://Scene/TitleScreen/ListeningKey.tscn")

#----------									----------#
#	Initialisation (rename) + fonctions associés
#----------									----------#
#La fonction rename doit être appelé par le node parent
#après l'instantiation du node ActionCombo afin de procéder
#à son initialisation

func rename(action: String):
	self.name = action
	get_node("Label").text = action
	setup_input(InputMap.action_get_events(action)[0])

func setup_input(event):
	if InputManager.is_key_config_mode():
		setup_input_text(event)
	else:
		setup_input_image(event)

func setup_input_image(event):
	get_node("InputImg").load_image(event)
	toggle_to_text_input(false)

func setup_input_text(event):
	get_node("InputText").text = InputManager.convert_event_as_text(event)
	toggle_to_text_input(true)

func toggle_to_text_input(config: bool):
	get_node("InputText").visible = config
	get_node("InputImg").visible = !config

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Lance la reconfiguration de l'input via un listener
func _on_label_pressed():
	start_listening_input(self.name)

#Creation listener
#Récupération de l'event
#Update
#Libébration de l'espace
func start_listening_input(action: String):
	var instance = Scene.instantiate()
	get_node("/root").add_child(instance)
	var event = await instance.listen(action)
	update_input_text(event)
	instance.queue_free()

func update_input_text(event):
	if not event == null:
		setup_input(event)
