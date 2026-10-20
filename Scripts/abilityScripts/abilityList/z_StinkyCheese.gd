extends BaseBox
var surroundingBoxes = []
func _init() -> void:
	GivenName = "Stinky Cheese"
	GivenWeight = 450
	GivenType = "Wooden"
	GivenIncome = 250
	GivenAbility = "When Loaded: Steal 100 Income from 1 adjacent unit and double this units income"
	GivenHealth = 500
	height = 2
	size = Vector3(2,2,2)
	canBeDestroyed = true
	

func WhenloadedAbility():
	await get_tree().process_frame
	await get_tree().process_frame
	var pickedBox = surroundingBoxes.pick_random()
	
	if surroundingBoxes.is_empty() or not truck.boxesInTruck.has(self):
		return
	for i in surroundingBoxes:
		print(i.GivenName)
	if pickedBox.GivenIncome <= 100:
		statHandler("Income",100,1)
		statHandler("Income",GivenIncome,1)
		pickedBox.statHandler("Income",-pickedBox.GivenIncome,1)
	else:
		statHandler("Income",100,1)
		statHandler("Income",GivenIncome,1)
		pickedBox.statHandler("Income",-100,1)

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		surroundingBoxes.append(body)


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	surroundingBoxes.erase(body)
