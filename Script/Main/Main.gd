extends Node


var Scene = load("res://Scene/TitleScreen/TitleScreen.tscn")
var Instance

func _ready():
	Instance = Scene.instantiate()
	add_child(Instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
