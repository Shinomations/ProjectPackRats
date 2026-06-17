extends Node


# Called when the node enters the scene tree for the first time.

var GivenName = "Book Box"
var GivenWeight = 100
var GivenType = "Cardboard"
var GivenIncome = 250
var GivenAbility = "Passive: boxes next to this have -10 weight (Can't be 0)"


func _ready() -> void:
	print(GivenName)
	
