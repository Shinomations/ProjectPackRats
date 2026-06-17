extends Node


# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.

var GivenName = "Box of Wires"
var GivenWeight = 25
var GivenType = "Cardboard"
var GivenIncome = 200
var GivenAbility = "When Destroyed: Double the Income of the Box that destroyed this"

func _ready() -> void:
	print(GivenName)
