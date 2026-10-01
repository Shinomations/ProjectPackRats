extends BaseBox

func _init() -> void:
	GivenName = "Drink Pallet"
	GivenWeight = 375
	GivenType = "Wooden"
	GivenIncome = 300
	GivenAbility = "Passive: All boxes above this get +100 Income"
	GivenHealth = 600
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true
	

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		boxesAboveThis.append(body)
		body.statHandler("Income",100,2)


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and boxesAboveThis.has(body):
		boxesAboveThis.erase(body)
		body.statHandler("Income",-100,0)
