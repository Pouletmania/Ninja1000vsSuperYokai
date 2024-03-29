extends VBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script de gestion d'initialisation du focus si le controller est un Joypad

#----------				----------#
#	Ready + fonctions associés
#----------				----------#

func _ready():
	InputManager.switch_configuration.connect(_on_switch_configuration)

#----------				----------#
#	Process + fonctions associés
#----------				----------#

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and is_visible_in_tree():
		get_node("Quit").grab_focus()

#----------				----------#
#	Draw + fonctions associés
#----------				----------#

func _draw():
	if not InputManager.is_key_config_mode():
		init_focus()

func init_focus():
	get_child(0).grab_focus()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de changement de configuration
func _on_switch_configuration():
	if is_visible_in_tree():
		_draw()

