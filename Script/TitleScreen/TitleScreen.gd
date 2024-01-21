extends MarginContainer

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché au node TitleScreen permetant la gestion des changements des
#différent menu de l'écran titre

var NewGame = preload("res://Scene/SandBox.tscn").instantiate()

#----------				----------#
#	Signal + fonctions associés
#----------				----------#

#Appelé lors de l'appuie sur le bouton New Game du menu principale
func _on_new_game_pressed():
	get_tree().root.get_node("Main").add_child(NewGame)
	queue_free()

#Appelé lors de l'appuie sur le bouton Option du menu principale
func _on_option_pressed():
	get_node("MainScreen").visible = false
	get_node("OptionScreen").visible = true

#Appelé lors de l'appuie sur le bouton Back de n'importe qu'elle menu enfant
func _on_back_pressed():
	get_node("MainScreen").visible = true
	get_node("OptionScreen").visible = false

#Appelé lors de l'appuie sur le bouton Quit
func _on_quit_pressed():
	get_tree().quit()
