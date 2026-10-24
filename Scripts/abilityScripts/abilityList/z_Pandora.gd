extends BaseBox
var abilityTriggered: bool
func _init() -> void:
	GivenName = "Pandora's Box"
	GivenWeight = 150
	GivenType = "Ceramic"
	GivenIncome = 0
	GivenAbility = "When another box is loaded: +5 income \n Activate: Add this units income to ALL units Weight"
	GivenHealth = 500
	height = 1
	size = Vector3(1,1,1)
	canBeDestroyed = true
	
	
func otherBoxLoadedAbility(_body):
	GivenIncome += 5

func ActivateAbility():
	if abilityTriggered == true:
		return
	
	abilityTriggered = true
	
	var ALL = get_tree().get_nodes_in_group("boxes")

	for i in ALL:
		print(i)
		i.GivenWeight += GivenIncome

	GivenAbility = "Can't trigger again"
