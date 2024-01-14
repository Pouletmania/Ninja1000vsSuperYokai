extends CheckButton

var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if try_to_load_config_files():
		set_pressed_no_signal(Config.get_value("InputConfig", "AutoLoad", false))
	else:
		set_pressed_no_signal(false)

func _on_toggled(button_pressed):
	load_current_config()
	write_in_buffer(button_pressed)
	write_buffer_in_config_file()

func try_to_load_config_files():
	var err = load_current_config()
	if err != OK:
		return false
	else:
		return true

func load_current_config():
	return Config.load("res://Config/ConfigFiles.cfg")

func write_in_buffer(value):
	Config.set_value("InputConfig", "AutoLoad", value)

func write_buffer_in_config_file():
	Config.save("res://Config/ConfigFiles.cfg")
