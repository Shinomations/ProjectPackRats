extends BaseBox
var timer = 1

func _init() -> void:
	GivenName = "IED"
	GivenWeight = 75
	GivenType = "Metal"
	GivenIncome = 250
	GivenAbility = "When Loaded: the next box you load gets destroyed"
	GivenHealth = 100
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
	
