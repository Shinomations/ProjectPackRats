extends Label3D

var parent
var WeightLeft = 5000
@onready var area_3d: Area3D = $"../../../.."
func _ready() -> void:
	parent = area_3d.boxesInTruck


func update():
	


	for i in parent:
		#income calculations
		
		if is_instance_valid(i):
			WeightLeft -= i.GivenWeight

	text = "Weight Capacity:" + str(WeightLeft)
	

	if WeightLeft <= 0:
		area_3d.LeavingPath.loadingEnded()
