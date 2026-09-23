extends BaseBox

func _init() -> void:
	GivenName = "Box of Glassware"
	GivenWeight = 200
	GivenType = "Cardboard"
	GivenIncome = 550
	GivenAbility = "If anything is placed above this, destroy this"
	GivenHealth = 50
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject:
			self.queue_free()
