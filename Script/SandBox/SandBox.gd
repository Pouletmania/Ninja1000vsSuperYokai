extends Node2D

#-------		--------#
#	Chemin node enfant
#-------		--------#
func _process(_delta):
	if Input.is_action_just_pressed("Menu in game"):
		get_tree().root.add_child(Files.TitleScreenScene.instantiate())
		queue_free()
