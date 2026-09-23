extends BaseBox
var surroundingBoxes: Array = []
var shots = 6

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

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		surroundingBoxes.append(body)

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and surroundingBoxes.has(body):
		surroundingBoxes.erase(body)

func MergeAbility():
	var rnd
	var picked:Array = []
	for i in shots:
		rnd = surroundingBoxes.pick_random()
		picked.append(rnd)
		print(rnd.GivenName)
	
	for i in picked:
		if shots > 0:
			i.GivenWeight -= 10
			shots -= 1
	surroundingBoxes = []
	shots = 6
