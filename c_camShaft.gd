extends Client

func _init() -> void:
	clientAbility = "If you complete the game with only 1 truck multipler is 7x \n otherwise its 2x"
	
	
	
func beforeAbility():
	player.finalScreen.trucksMulti = 7

func afterAbility(trucksUsed: int):
	if trucksUsed == 1:
		player.finalScreen.trucksMulti = 2
