extends BaseBox

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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == self or body.is_in_group("player") or player.pickedObject == self:
		return
	
	if body.is_in_group("boxes") and body != self:
		boxesAboveThis.append(body)
		if body.has_method("MergeAbility"):
			body.MergeAbility()
			await get_tree().create_timer(.2).timeout
			body.MergeAbility()

		queue_free()
