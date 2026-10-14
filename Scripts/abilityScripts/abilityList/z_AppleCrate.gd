extends BaseBox

func _init() -> void:
	GivenName = "Apple Crate"
	GivenWeight = 200
	GivenType = "Organic"
	GivenIncome = 100
	GivenAbility = "When Loaded: For each Organic Unit in the truck \n give this +10 Income and Health"
	GivenHealth = 75
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true
	
func WhenloadedAbility():
	if truck.boxesInTruck.has(self) and not hasRun:
		for i in truck.boxesInTruck:
			if i.GivenType == "Organic":
				GivenIncome += 10
				GivenHealth += 10
			
		hasRun = false
