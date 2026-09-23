extends BaseBox

var BoxesNotToAffect: Array = []

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
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject:
			if not BoxesNotToAffect.has(body):
				body.GivenHealth -= 25
				BoxesNotToAffect.append(body)
				if "Destroyer" in body and body.GivenHealth <= 0:
					body.Destroyer = self
					body.ability()
