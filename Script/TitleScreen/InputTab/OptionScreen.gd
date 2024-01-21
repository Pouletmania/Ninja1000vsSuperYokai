extends VBoxContainer

#----------				----------#
#	Process + fonctions associés
#----------				----------#

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and is_visible_in_tree():
		get_node("Back").grab_focus()
