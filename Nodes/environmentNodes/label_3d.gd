extends Label3D

var parent

@onready var area_3d: Area3D = $"../../../.."
func _ready() -> void:
	parent = area_3d.boxesInTruck


func update():
	var totalIncome = 0

	
	for i in parent:
		if i == null:
			continue
		#income calculations
		print("I is = " + str(i))
		totalIncome += i.GivenIncome

		
	text = "$" + str(totalIncome)# + "\n" + "Weight Capacity:" + str(totalWeight)
