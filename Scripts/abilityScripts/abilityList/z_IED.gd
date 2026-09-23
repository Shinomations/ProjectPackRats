extends BaseBox
var timer = 1

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

func TruckEnterAbilityability():
	if truck.boxesInTruck.has(self):
		if timer == 0:
			var dynamic_can_destroy = truck.bodySelected.get("canBeDestroyed") if "canBeDestroyed" in truck.bodySelected else true
			print(dynamic_can_destroy)
			if dynamic_can_destroy:
				if "Destroyer" in truck.bodySelected:
					truck.bodySelected.Destroyer = self
					if truck.bodySelected.has_method("ability"):
						truck.bodySelected.ability()
				truck.bodySelected.queue_free()
		timer -= 1
	
