extends Control

@onready var text = $MarginContainer/VBoxContainer/RichTextLabel

var player

func statsShow():
	player = get_tree().get_first_node_in_group("player")
	self.visible = true
	text.text = "Income Made:" + str(player.totalScore)
