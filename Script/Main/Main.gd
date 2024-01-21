extends Node

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node Main
#Point d'entrée de l'execution du jeu après la génération des nodes Autoload

#---------------#
#	Variable
#---------------#
var FirstScene = preload("res://Scene/TitleScreen/TitleScreen.tscn").instantiate()

#----------				----------#
#	Ready + fonctions associés
#----------				----------#
func _ready():
	add_child(FirstScene)
