extends BaseBox

func _init() -> void:
	GivenName = "Poisonios Mushroom"
	GivenWeight = 10
	GivenType = "Organic"
	GivenIncome = 20
	GivenAbility = "When SpeedPacked: Swap the Income and weight of ALL the BOXES outside the truck"
	GivenHealth = 10
	height = 2
	size = Vector3(2,2,2)
	canBeDestroyed = true
	
func SpeedpackAbility():
	for i in get_tree().get_nodes_in_group("boxes"):
		if truck.boxesInTruck.has(i):
			return
		var startIncome: int = i.GivenIncome
		var startWeight: int = i.GivenWeight
		
		i.GivenIncome = startWeight
		i.GivenWeight = startIncome
		print(i.GivenName)
