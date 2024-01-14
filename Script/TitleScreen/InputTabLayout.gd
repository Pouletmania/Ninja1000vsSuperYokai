extends VBoxContainer

var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_up():
	load_current_config()
	write_in_buffer()
	write_buffer_in_config_file()

func load_current_config():
	Config.load("res://Config/ConfigFiles.cfg")

func write_in_buffer():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			Config.set_value("Input", action, InputMap.action_get_events(action)[0].as_text())

func write_buffer_in_config_file():
	Config.save("res://Config/ConfigFiles.cfg")

func _on_load_button_up():
	get_node("GridInput").construct_grid(true)



