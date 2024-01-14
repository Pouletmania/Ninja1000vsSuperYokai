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
		switch_listening(false)
		InputListen = event.as_text()
		print(get_node("/root"))

func listen():
	switch_listening(true)
	while IsListening:
		await get_tree().create_timer(0.2).timeout
	return InputListen

func switch_listening(value: bool):
	get_tree().paused = value
	IsListening = value
	set_process_input(value)
