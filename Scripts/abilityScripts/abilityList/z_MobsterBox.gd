extends BaseBox
var Mobsters: Array[Callable] = [Ogre,Ram,Lady]
var timer: int = 10
var boxesAlreadyAdded: Array = []
func _init() -> void:
	GivenName = "Mobster Cage"
	GivenWeight = 1500
	GivenType = "Metal"
	GivenIncome = 2000
	GivenAbility = "This has a random mobster in it, it changes this units stats"
	GivenHealth = 5000
	height = 4
	size = Vector3(4,4,4)
	canBeDestroyed = true

func _ready():
	super()
	scale *= 3
	size = scale
	Mobsters.pick_random().call()
func Ogre(): #Day 6
	timer = 20
	GivenName = "Mobster Cage: The Ogre"
	GivenWeight = 2000
	GivenType = "Metal"
	GivenIncome = 2000
	GivenAbility = "Timer" + str(timer) + ": Escape"
	GivenHealth = 5000

func Ram(): #Day 9
	timer = 10
	GivenName = "Mobster Cage: The Ram"
	GivenWeight = 1150
	GivenType = "Metal"
	GivenIncome = 2000
	GivenAbility = "Timer" + str(timer) + ": If the Trucks Income isn't Double this Units, Escape"
	GivenHealth = 5000

func Lady(): #Day 14
	timer = 15
	GivenName = "Mobster Cage: The Lady"
	GivenWeight = 1075
	GivenType = "Metal"
	GivenIncome = 2000
	GivenAbility = "Timer" + str(timer) + ": If you haven't Destroyed 10 Units, Escape"
	GivenHealth = 5000 

func otherBoxLoadedAbility(body):
	if boxesAlreadyAdded.has(body):
		return
	if GivenName == "Mobster Cage: The Ogre":
		timer -= 1
		GivenAbility = "Timer" + str(timer) + ": Escape"
		if timer == 0:
			queue_free()
	if GivenName == "Mobster Cage: The Ram":
		timer -= 1
		GivenAbility = "Timer" + str(timer) + ": If the Trucks Income isn't Double this Units, Escape"
		if timer == 0 and not truck.TotalScore == GivenIncome * 2:
			queue_free()
	if GivenName == "Mobster Cage: The Lady":
		timer -= 1
		GivenAbility = "Timer" + str(timer) + ": If you haven't Destroyed" + str(stats.objectsDestroyed) +"Units, Escape"
		if timer == 0 and stats.objectsDestroyed < 10:
			queue_free()
	
