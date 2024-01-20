extends VBoxContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node InputTabLayout permetant la génération automatique de
#l'onglet d'option des inputs.
#Est composé d'une grille GrdiInput permetant la conguration unitaire des inputs
#et d'un menu permetant l'acces au fichier de configuration (Load / Save)

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

func _draw():
	get_node("GridInput").LastFocus = 0
