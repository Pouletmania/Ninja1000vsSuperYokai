extends Node

var InputListen: String
var IsListening: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent):
	if event is InputEventKey:
		set_process_input(false)
		get_tree().paused = false
		IsListening = false
		InputListen = event.as_text()

func listen():
	get_tree().paused = true
	IsListening = true
	set_process_input(true)
	while IsListening:
		await get_tree().create_timer(1.0).timeout
	return InputListen
