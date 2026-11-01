extends BaseBox

func _init() -> void:
	GivenName = "Trophie"
	GivenWeight = 10
	GivenType = "Plastic"
	GivenIncome = 50
	GivenAbility = "When Speedpacked: Double this units income if the number of boxes loaded in a factor of 5"
	GivenHealth = 500
	height = 2
	size = Vector3(2,2,2)
	canBeDestroyed = true

func SpeedpackAbility():
	if stats.objectsLoaded % 5 == 0:
		GivenIncome *= 2
