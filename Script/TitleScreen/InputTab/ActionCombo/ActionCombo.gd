extends HBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché à un ActionCombo permetant la gestion d'une configuration d'un
#input.

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

#Clear focus sur le bouton (Evite que l'input écouté soit interprété via le gui)
#Creation listener
#Récupération de l'event
#Update
#Libébration de l'espace
#Timer de 0.1s avant récupération du focus si controller manette
#   (Evite que l'input écouté soit interprété via le gui)
func start_listening_input(action: String):
	InputManager.clear_all_focus()
	var instance = Scene.instantiate()
	get_node("/root").add_child(instance)
	var event = await instance.listen(action)
	update_input_text(event)
	instance.queue_free()
	if not InputManager.is_key_config_mode():
		await get_tree().create_timer(0.1).timeout
		get_node("Label").grab_focus()

func update_input_text(event):
	if not event == null:
		setup_input(event)
