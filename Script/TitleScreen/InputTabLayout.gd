extends VBoxContainer

var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_up():
	var err = Config.load("res://Config/ConfigFiles.cfg")
	
	# If the file didn't load, ignore it.
	if err != OK:
		print("Error : No config Files load")
		
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			Config.set_value("Input", action, InputMap.action_get_events(action)[0].as_text())
			print("Add Config : " + action + " : " + InputMap.action_get_events(action)[0].as_text())
	Config.save("res://Config/ConfigFiles.cfg")
	print("Save Config")



func _on_load_button_up():
	var err = Config.load("res://Config/ConfigFiles.cfg")
	
	# If the file didn't load, ignore it.
	if err != OK:
		print("Error : No config Files load")
	else:
		print("Load Config")
	
	

