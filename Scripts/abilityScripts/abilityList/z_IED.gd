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

func otherBoxLoadedAbility(body):
	if truck.boxesInTruck.has(self): 
		if  timer >= 0 and body != self:
			timer -= 1
			GivenAbility = "Timer" + str(timer) + ": Place 2 indestructables next to this; else Destroy all boxes around this"
			print("Boxes needed" + str(surroundingboxes))
		if timer == 0:
			#Very important DO NOT DELETE box will not work otherwise
			await get_tree().process_frame
			await get_tree().process_frame
			surroundingboxes.erase(self)
			boxesNeeded = 2
			for i in surroundingboxes:
				if is_instance_valid(i) and i.is_in_group("boxes") and not i.canBeDestroyed == true:
					boxesNeeded -= 1
			if boxesNeeded != 0 :
				for i in surroundingboxes:
					if i.is_in_group("boxes") and i.canBeDestroyed == true:
						if "Destroyer" in i:
							body.Destroyer = self
							body.ability()
						i.queue_free()
				await get_tree().process_frame
				queue_free()
		

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		surroundingboxes.append(body)


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	surroundingboxes.erase(body)
