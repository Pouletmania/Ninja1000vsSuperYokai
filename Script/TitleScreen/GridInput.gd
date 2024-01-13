extends GridContainer

var InputConfigurationInstance = load("res://Scene/TitleScreen/ActionCombo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# List of the custom input of the game
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			add_action_combo(action)

# Creation process of a combo "Action / Input"
func add_action_combo(action: String):
	var actionCombo = InputConfigurationInstance.instantiate()
	actionCombo.rename(action)
	add_child(actionCombo)
