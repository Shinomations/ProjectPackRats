extends Control

@onready var text = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/RichTextLabel

var player
var speedPack
var trucksMulti = 5
var increasingSpeed: int = 100
func statsShow():
	player = get_tree().get_first_node_in_group("player")
	speedPack = get_tree().get_first_node_in_group("speedPack")
	self.visible = true
	var i: int = 1
	while i < player.FinalScore:
		await get_tree().process_frame
		text.text = (
			"Income Made:" + str(i) + "\n" 
			+ "Speedpack Total: " + str(speedPack.speedPackIncomeTotal)
			+ "\nMultiplier: " + str(trucksMulti) + "x\n" 
			+ "-----------------\n" 
			+ "Total:"
			)
		i += increasingSpeed
		if i >= player.FinalScore:
			i = 0
			break
	while i < speedPack.speedPackIncomeTotal:
		await get_tree().process_frame
		text.text = (
			"Income Made:" + str(player.FinalScore) + "\n" 
			+ "Speedpack Total: " + str(i)
			+ "\nMultiplier: " + str(trucksMulti) + "x\n" 
			+ "-----------------\n" 
			+ "Total: "
			)
		i += increasingSpeed
		if i >= speedPack.speedPackIncomeTotal:
			i = 0
			break
	while i < trucksMulti:
		await get_tree().process_frame
		text.text = (
			"Income Made:" + str(player.FinalScore) + "\n" 
			+ "Speedpack Total: " + str(speedPack.speedPackIncomeTotal)
			+ "\nMultiplier: " + str(i) + "x\n" 
			+ "-----------------\n" 
			+ "Total: "
			)
		i += 1
		if i >= trucksMulti:
			i = 0
			break
	while i < (player.FinalScore + speedPack.speedPackIncomeTotal) * trucksMulti:
		await get_tree().process_frame
		text.text = (
			"Income Made:" + str(player.FinalScore) + "\n" 
			+ "Speedpack Total: " + str(speedPack.speedPackIncomeTotal)
			+ "\nMultiplier: " + str(trucksMulti) + "x\n" 
			+ "-----------------\n" 
			+ str(i)
			)
		i += increasingSpeed
		if i >= (player.FinalScore + speedPack.speedPackIncomeTotal) * trucksMulti:
			i = 0
			break
	text.text = (
			"Income Made:" + str(player.FinalScore) + "\n" 
			+ "Speedpack Total: " + str(speedPack.speedPackIncomeTotal)
			+ "\nMultiplier: " + str(trucksMulti) + "x\n" 
			+ "-----------------\n" 
			+ str((player.FinalScore + speedPack.speedPackIncomeTotal) * trucksMulti)
			)
