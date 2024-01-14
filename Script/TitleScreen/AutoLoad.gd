extends CheckButton

var Config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var err = Config.load("res://Config/ConfigFiles.cfg")
	
	# If the file didn't load, ignore it.
	if err != OK:
		set_pressed_no_signal(false)
	else:
		set_pressed_no_signal(Config.get_value("InputConfig", "AutoLoad", false))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(button_pressed):
	Config.set_value("InputConfig", "AutoLoad", button_pressed)
	Config.save("res://Config/ConfigFiles.cfg")
