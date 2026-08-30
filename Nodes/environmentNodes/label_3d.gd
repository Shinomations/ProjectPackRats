extends Label3D

var parent
var WeightLeft = 5000

func _ready() -> void:
	parent = get_parent().boxesInTruck
	
func update():
	var totalIncome = 0
	var totalWeight = 5000
	
	for i in parent:
		#income calculations
		print("I is = " + str(i))
		totalIncome += i.GivenIncome
		totalWeight -= i.GivenWeight
		
	text = "Income:" + str(totalIncome) + "\n" + "Weight Capacity:" + str(totalWeight)
