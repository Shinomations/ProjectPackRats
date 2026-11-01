extends BaseBox
var damageCount: int = 0

func _init() -> void:
	GivenName = "Box of Bones"
	GivenWeight = 110
	GivenType = "Cardboard"
	GivenIncome = 50
	GivenAbility = "Passive: Multiply this units base income by how many times its been damaged"
	GivenHealth = 150
	height = 1
	size = Vector3(1,1,1)
	canBeDestroyed = true

func WhenDamaged():
	print("abilityActivated")
	damageCount += 1
	GivenIncome = baseIncome * damageCount
