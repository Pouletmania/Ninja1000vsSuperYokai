extends GridContainer
var InputConfigurationInstance = load("res://Scene/TitleScreen/InputConfiguration.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#Creation automatique du couple "Label / Input" des action de l'InputMap hors action UI
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			add_action_configuration(action)


func add_action_configuration(action: String):
	var inputConfig = InputConfigurationInstance.instantiate()
	inputConfig.set_action(action)
	add_child(inputConfig)
