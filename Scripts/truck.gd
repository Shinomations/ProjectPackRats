extends Area3D

var remainingCapacity: float = 1.0
@export var capacityNeededTooLeave = 0.10
var TotalScore: float = 0.0
var truckTextUpdate
var truckTextUpdate2
var boxVolume
var boxScore 
var bodySelected
@onready var truckVolume: float = getBoxVolume(self)
@export var LeavingPath: Path3D
var boxesInTruck:Array = []
var player

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
	truckTextUpdate = find_child("Label3D")
	truckTextUpdate2 = find_child("Label3D2")
	player = get_tree().get_first_node_in_group("player")
	print(LeavingPath)
	
	
func _on_body_entered(body: Node3D) -> void:
	bodySelected = body
	boxVolume = getBoxVolume(body)
	boxScore = getBoxScore(body)
	if truckVolume <= 0.0 or boxVolume <= 0.0:
		return
		
	boxesInTruck.append(body)
	truckTextUpdate.update()
	truckTextUpdate2.update()
	updateCapacity(-boxVolume / truckVolume, "entered")
	updateScore(boxScore)
	player.totalScore = TotalScore
	
	if body.has_method("TruckEnterAbilityability"):
		for i in boxesInTruck:
			if i.has_method("TruckEnterAbilityability"):
				i.TruckEnterAbilityability()
			await get_tree().create_timer(0.5).timeout
	print("boxes in truck rn: " + str(boxesInTruck.size())," Boxes in world: " + str(get_tree().get_nodes_in_group("boxes").size()))
	if remainingCapacity < capacityNeededTooLeave or truckTextUpdate2.WeightLeft <= 0 or boxesInTruck.size() == get_tree().get_nodes_in_group("boxes").size():
		LeavingPath.loadingEnded()
	print(remainingCapacity)
func _on_body_exited(body: Node3D) -> void:

	boxVolume = getBoxVolume(body)
	boxScore = getBoxScore(body)
	if truckVolume <= 0.0 or boxVolume <= 0.0:
		return

	if body in boxesInTruck:
		boxesInTruck.erase(body)
		truckTextUpdate.update()
		truckTextUpdate2.update()
	updateCapacity(boxVolume / truckVolume, "exited")
	updateScore(-(boxScore))
	if body.is_in_group("player") or body.is_in_group("truck"):
		return
	
	print(remainingCapacity)
func updateCapacity(relativeChange: float, action: String) -> void:
	remainingCapacity += relativeChange


func updateScore(score: float) -> void:
	TotalScore += score
