extends BaseBox
var timer = 5
var surroundingboxes = []
var boxesNeeded = 2
func _init() -> void:
	GivenName = "IED"
	GivenWeight = 75
	GivenType = "Metal"
	GivenIncome = 250
	GivenAbility = "Timer" + str(timer) + ": Place 2 indestructables next to this; else Destroy all boxes around this"
	GivenHealth = 100
	height = 1
	canBeDestroyed = true

func otherBoxLoadedAbility(_body):
	if truck.boxesInTruck.has(self): 
		if  timer >= 0:
			timer -= 1
			GivenAbility = "Timer" + str(timer) + ": Place 2 indestructables next to this; else Destroy all boxes around this"
			print("Boxes needed" + str(boxesNeeded))
		if timer == 0:
			boxesNeeded = 2
			for i in surroundingboxes:
				if i.is_in_group("boxes") and not i.canBeDestroyed == true:
					boxesNeeded -= 1
					print("Boxes needed" + str(surroundingboxes.GivenName))
			if boxesNeeded != 0:
				for i in surroundingboxes:
					if i.is_in_group("boxes") and i.canBeDestroyed == true:
						i.queue_free()
		



func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body != self:
		surroundingboxes.append(body)


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	surroundingboxes.erase(body)
