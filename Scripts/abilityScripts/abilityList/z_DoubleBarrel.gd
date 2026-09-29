extends BaseBox

var surroundingBoxes: Array[Node3D] = []
var shots: int = 2

func _init() -> void:
	GivenName = "Shotgun case"
	GivenWeight = 75
	GivenType = "Plastic"
	GivenIncome = 100
	GivenAbility = "When Merge with: Shoot 2 shots at surrounding boxes give them -50 weight"
	GivenHealth = 100
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true
	

func MergeAbility():
	var rnd
	var picked:Array = []
	for i in shots:
		if not surroundingBoxes.is_empty():
			rnd = surroundingBoxes.pick_random()
			picked.append(rnd)
		else:
			picked.append(self)
	for i in picked:
		if shots > 0:
			i.GivenWeight -= 50
			shots -= 1
	surroundingBoxes = []
	shots = 2
