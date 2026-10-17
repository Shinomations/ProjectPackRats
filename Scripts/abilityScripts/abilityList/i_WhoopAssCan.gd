extends BaseBox

func _init() -> void:
	GivenName = "Can of Whoop Ass"
	GivenWeight = 1
	GivenType = "item"
	GivenIncome = 100
	GivenAbility = "Dont Open this...(Press E while holding)"
	GivenHealth = 10
	height = 0.5
	size = Vector3(0.5,0.5,0.5)
	canBeDestroyed = true
	
func UseAbility():
	emitParticles("Use",global_position)
