extends BaseBox

var Destroyer

func _init() -> void:
	GivenName = "Ammo box"
	GivenWeight = 10
	GivenType = "Plastic"
	GivenIncome = 20
	GivenAbility = "This can Merge with the box Above it \n repeat its merge ability again"
	GivenHealth = 30
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true

func ability() -> void:
	Destroyer.GivenIncome *= 2
	
