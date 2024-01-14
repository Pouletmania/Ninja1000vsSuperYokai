extends VBoxContainer

var Config = ConfigFile.new()

func _on_save_button_up():
	load_current_config()
	write_in_buffer()
	write_buffer_in_config_file()

func _on_load_button_up():
	get_node("GridInput").rebuild_grid()

func load_current_config():
	Config.load(Files.Config)

func write_in_buffer():
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			Config.set_value("Input", action, InputMap.action_get_events(action)[0].keycode)

func write_buffer_in_config_file():
	Config.save(Files.Config)
