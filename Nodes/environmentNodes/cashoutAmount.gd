extends Label3D

var parent

@onready var truck = $".." #this grabs the parent of self, then its parent and so on
func _ready() -> void:
	parent = truck.boxesInTruck


func update():
	var totalIncome = 0

	
	for i in parent:
		if i == null:
			continue
		#income calculations
		
		totalIncome += i.GivenIncome

		
	text = "$" + str(totalIncome)# + "\n" + "Weight Capacity:" + str(totalWeight)
