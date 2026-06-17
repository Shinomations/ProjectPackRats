extends Node


# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.

var GivenName = "Box of Glassware"
var GivenWeight = 10
var GivenType = "Wooden"
var GivenIncome = 500
var GivenAbility = "Passive: destroy this when a box with more weight is placed above this one"


func _ready() -> void:
	print(GivenName)
