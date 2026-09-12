extends Control

@onready var text = $MarginContainer/VBoxContainer/RichTextLabel

var player
var speedPack
var trucksMulti = 5
func statsShow():
	player = get_tree().get_first_node_in_group("player")
	speedPack = get_tree().get_first_node_in_group("speedPack")
	self.visible = true
	text.text = (
		"Income Made:" + str(player.FinalScore) + "\n" 
		+ "Speedpack Total: " + str(speedPack.speedPackIncomeTotal)
		+ "\nMultiplier: " + str(trucksMulti) + "x\n" 
		+ "-----------------\n" 
		+ str((player.FinalScore + speedPack.speedPackIncomeTotal) * trucksMulti)
		)
