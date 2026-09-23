extends BaseBox

const honey = preload("res://Nodes/itemNodes/i_jarOfHoney.tscn")

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
	
	var honeySpawn = honey.instantiate()
	
	speedPack.itemMarker.add_child(honeySpawn)
	get_tree().current_scene.add_child(honeySpawn)
	
