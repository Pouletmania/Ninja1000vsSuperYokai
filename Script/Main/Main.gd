extends Node

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node Main
#Point d'entrée de l'execution du jeu après la génération des nodes Autoload

#----------				----------#
#	Ready + fonctions associés
#----------				----------#
func _ready():
	add_child(Files.TitleScreenScene.instantiate())
