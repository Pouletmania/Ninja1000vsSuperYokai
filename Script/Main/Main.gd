extends Node

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node Main
#Point d'entrée de l'execution du jeu après la génération des nodes Autoload

#---------------#
#	Variable
#---------------#
var FirstScene = load("res://Scene/TitleScreen/TitleScreen.tscn")
var Instance

#----------				----------#
#	Ready + fonctions associés
#----------				----------#
func _ready():
	Instance = FirstScene.instantiate()
	add_child(Instance)
