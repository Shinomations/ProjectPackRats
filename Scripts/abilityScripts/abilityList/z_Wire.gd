extends BaseBox

var Destroyer

func _init() -> void:
	GivenName = "Box of Wires"
	GivenWeight = 300
	GivenType = "Cardboard"
	GivenIncome = 200
	GivenAbility = "When Destroyed: Double the Income of the box that destroyed this"
	GivenHealth = 40
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true

func ability() -> void:
	Destroyer.GivenIncome *= 2
	
