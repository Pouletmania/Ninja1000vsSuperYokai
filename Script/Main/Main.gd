extends Node

var FirstScene = load("res://Scene/TitleScreen/TitleScreen.tscn")
var Instance

func _ready():
	Instance = FirstScene.instantiate()
	add_child(Instance)


