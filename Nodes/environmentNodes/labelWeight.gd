extends Label3D

var parent
var WeightLeft = 100
@onready var area_3d: Area3D = $"../../../.."
func _ready() -> void:
	parent = area_3d.boxesInTruck


func update():
	
	var totalWeight = 100

	for i in parent:
		#income calculations
		
		if is_instance_valid(i):
			totalWeight -= i.GivenWeight
		
	text = "Weight Capacity:" + str(totalWeight)
	
	WeightLeft = totalWeight
	if WeightLeft <= 0:
		area_3d.LeavingPath.loadingEnded()
