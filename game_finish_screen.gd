extends Control

@onready var text = $MarginContainer/VBoxContainer/RichTextLabel

var player
var trucksMulti = 5
func statsShow():
	player = get_tree().get_first_node_in_group("player")
	self.visible = true
	text.text = (
		"Income Made:" + str(player.FinalScore) + "\n" 
		+ "Multiplier: " + str(trucksMulti) + "x\n" 
		+ "-----------------\n" 
		+ str(player.FinalScore * trucksMulti)
		)
