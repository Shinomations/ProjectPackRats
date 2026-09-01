extends Label3D

var parent
var WeightLeft = 5000
@onready var area_3d: Area3D = $"../../../.."
func _ready() -> void:
	parent = area_3d.boxesInTruck


func update():
	
	var totalWeight = 5000
	
	for i in parent:
		#income calculations
		print("I is = " + str(i))

		totalWeight -= i.GivenWeight
		
	text = "Weight Capacity:" + str(totalWeight)
