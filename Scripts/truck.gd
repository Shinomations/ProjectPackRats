extends Area3D

var remainingCapacity: float = 1.0
var TotalScore: float = 0.0
var truckTextUpdate
@onready var truckVolume: float = getBoxVolume(self)
var boxesInTruck:Array = []


func getBoxVolume(node: Node3D) -> float:
	for child in node.get_children():
		if child is CollisionShape3D and child.shape is BoxShape3D:
			var realSize = child.shape.size * node.global_basis.get_scale()
			return realSize.x * realSize.y * realSize.z
	return 0.0
	
func getBoxScore(node: Node3D) -> float:
	for child in node.get_children():
		if child is CollisionShape3D and child.shape is BoxShape3D:
			var income = node.GivenIncome
			return income
	return 0.0

func _ready() -> void:
	truckTextUpdate = get_child(2)

func _on_body_entered(body: Node3D) -> void:
	
	var boxVolume = getBoxVolume(body)
	var boxScore = getBoxScore(body)
	if truckVolume <= 0.0 or boxVolume <= 0.0:
		return
		
	boxesInTruck.append(body)
	truckTextUpdate.update()
	updateCapacity(-boxVolume / truckVolume, "entered")
	updateScore(boxScore)
func _on_body_exited(body: Node3D) -> void:
	var boxVolume = getBoxVolume(body)
	var boxScore = getBoxScore(body)
	if truckVolume <= 0.0 or boxVolume <= 0.0:
		return
	
	if body in boxesInTruck:
		boxesInTruck.erase(body)
		truckTextUpdate.update()
	updateCapacity(boxVolume / truckVolume, "exited")
	updateScore(-(boxScore))

func updateCapacity(relativeChange: float, action: String) -> void:
	remainingCapacity += relativeChange
	print("Box %s! Took up %s%% of space." % [action, abs(relativeChange) * 100])
	print("Remaining truck capacity: %s%%" % [remainingCapacity * 100])

func updateScore(score: float) -> void:
	TotalScore += score
	
	print(TotalScore)
	
