extends Label3D

var parent
var WeightLeft = 5000
@onready var area_3d: Area3D = $"../../../.."
func _ready() -> void:
	parent = area_3d.boxesInTruck


func update():
	var weightInTruck = 5000

	for i in parent:
		#weight calculations
		if is_instance_valid(i):
			weightInTruck -= i.GivenWeight
	WeightLeft = weightInTruck
	text = "Weight Capacity:" + str(WeightLeft)
	

	if WeightLeft <= 0:
		area_3d.LeavingPath.loadingEnded()
