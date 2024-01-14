extends CheckButton

var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not try_to_load_config_files():
		set_pressed_no_signal(false)
	else:
		set_pressed_no_signal(Config.get_value("InputConfig", "AutoLoad", false))

func try_to_load_config_files():
	var err = Config.load("res://Config/ConfigFiles.cfg")
	if err != OK:
		return false
	else:
		return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(button_pressed):
	Config.load("res://Config/ConfigFiles.cfg")
	Config.set_value("InputConfig", "AutoLoad", button_pressed)
	Config.save("res://Config/ConfigFiles.cfg")
