extends BaseBox

var surroundingBoxes: Array[Node3D] = []


func _init() -> void:
	GivenName = "AWP"
	GivenWeight = 375
	GivenType = "Plastic"
	GivenIncome = 450
	GivenAbility = "When merged with: Shoot 1 shot infront of this, everything hit gets -100 weight"
	GivenHealth = 500
	height = 2
	size = Vector2(2,2)
	canBeDestroyed = true
	

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		surroundingBoxes.append(body)

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and surroundingBoxes.has(body):
		surroundingBoxes.erase(body)

func MergeAbility() -> void:
	for i in surroundingBoxes:
		if is_instance_valid(i) and "GivenWeight" in i:
			i.GivenWeight -= 100
			
	surroundingBoxes.clear()
