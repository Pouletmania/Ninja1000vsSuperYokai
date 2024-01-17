extends TextureRect

#----------		---------#
#	Description Global
#----------		---------#
#Script attaché a un node de type TextureRect pour load de l'image associé de 
#manière safe

#La fonction lpad_image doit s'effectuer depuis le node qui va charger la texture 
#pour eviter des problèmes de compilation
func load_image(event):
	self.texture = load("res://Asset/GamepadInput/" + InputManager.convert_event_as_text(event) + ".png")
