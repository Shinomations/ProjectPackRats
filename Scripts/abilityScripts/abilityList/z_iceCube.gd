extends BaseBox

func _init() -> void:
	GivenName = "Ice Cube"
	GivenWeight = 200
	GivenType = "Organic"
	GivenIncome = 75
	GivenAbility = "When another box enters the truck: Give it +30 income"
	GivenHealth = 20
	height = 2
	size = Vector3(2,2,2)
	canBeDestroyed = true

func otherBoxLoadedAbility(body):
	body.statHandler("Income",30,1)
