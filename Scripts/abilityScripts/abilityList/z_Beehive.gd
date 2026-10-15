extends BaseBox

const honey = preload("res://Nodes/itemNodes/i_jarOfHoney.tscn")

func _init() -> void:
	GivenName = "Beehive"
	GivenWeight = 60
	GivenType = "Organic"
	GivenIncome = 50
	GivenAbility = "When another box is loaded: Add a honey clump to the speedpack"
	GivenHealth = 75
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true

func otherBoxLoadedAbility():
	
	var honeySpawn = honey.instantiate()
	
	honeySpawn.global_position = speedPack.itemMarker.global_position
	
