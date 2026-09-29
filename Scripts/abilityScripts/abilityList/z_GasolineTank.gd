extends BaseBox

@onready var viableSpots = $Area3D2

var boxesLeft
var bodies
var clearedAreas: Array = []
var usedAbility

func _init() -> void:
	GivenName = "Tank of Gas"
	GivenWeight = 500
	GivenType = "Liquid"
	GivenIncome = 250
	GivenAbility = "Passive: Completely cover this to half its Weight and Double its income"
	GivenHealth = 30
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true
	
func _process(_delta):
	super(_delta)
	ability()

func ability():
	if not truck:
		return
	if not truck.boxesInTruck.has(self):
		return
		
	bodies = viableSpots.get_children()
	var filledSlotsCount = 0
	var totalSlotsCount = 0
	
	for i in bodies:
		if i is Area3D:
			totalSlotsCount += 1
			var Overlappers = i.get_overlapping_bodies()
			
			var slotIsOccupied = false
			for body in Overlappers:
				if body != player and body != self:
					slotIsOccupied = true
					break 
			
			if slotIsOccupied:
				filledSlotsCount += 1

	var newBoxesLeft = totalSlotsCount - filledSlotsCount
	
	if newBoxesLeft != boxesLeft:
		boxesLeft = newBoxesLeft
		print("Spots covered: " + str(filledSlotsCount) + "/" + str(totalSlotsCount))

	if boxesLeft == 0 and not usedAbility:
		GivenWeight /= 2
		GivenIncome *= 2
		usedAbility = true
		print("ACHIEVED: Box is 100% surrounded and covered!")
		
	elif boxesLeft > 0 and usedAbility:
		GivenWeight *= 2
		GivenIncome /= 2
		usedAbility = false
		print("LOST COVERAGE: A spot was uncovered.")
