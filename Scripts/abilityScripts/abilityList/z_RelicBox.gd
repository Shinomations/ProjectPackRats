extends BaseBox

func _init() -> void:
	GivenName = "Box of Relics"
	GivenWeight = 300
	GivenType = "Cardboard"
	GivenIncome = 100
	GivenAbility = "When another box is loaded: +50 health to random unit in truck"
	GivenHealth = 100
	height = 1
	canBeDestroyed = true
	
func otherBoxLoadedAbility(_body):
	var box2upgrade = truck.boxesInTruck.pick_random()
	box2upgrade.GivenHealth += 50
	pass
