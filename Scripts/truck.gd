extends CharacterBody3D

@onready var weightRef = $WeightLabel
@onready var incomeRef = $incomeLabel
var remainingCapacity: float = 1.0
@export var capacityNeededTooLeave = 0.0
var TotalScore: float = 0.0
var boxVolume
var boxScore 
var bodySelected
@onready var truckVolume: float = getBoxVolume($Area3D)
@export var LeavingPath: Path3D
var boxesInTruck:Array = []
var boxesInTruckInContainer: Array = []
var player
var somethingInFront
var alreadyBeen: Array = []
var stats
var isleaving: bool = false
func getBoxVolume(node: Node3D) -> float:
	for child in node.get_children():
		if child is CollisionShape3D and child.shape is BoxShape3D:
			var realSize = child.shape.size * node.global_basis.get_scale()
			print(realSize)
			return realSize.x * realSize.y * realSize.z
	return 0.0
	
func getBoxScore(node: Node3D) -> float:
	for child in node.get_children():
		if child is CollisionShape3D and child.shape is BoxShape3D:
			var income = node.GivenIncome
			return income
	return 0.0
	
func _ready() -> void:
	stats = get_tree().get_first_node_in_group("GlobalStats")
	player = get_tree().get_first_node_in_group("player")
	
func updateCapacity(relativeChange: float, _action: String) -> void:
	remainingCapacity += relativeChange

func updateScore(score: float) -> void:
	TotalScore += score


func _on_area_3d_body_entered(body: Node3D) -> void:
	if isleaving:
		return
	bodySelected = body
	boxVolume = getBoxVolume(body)
	boxScore = getBoxScore(body)
	print("truck volume is " + str(truckVolume),"boxVolume is " + str(boxVolume))
	if truckVolume <= 0.0 or boxVolume <= 0.0:
		return
	print("Entered")
	boxesInTruck.append(body)
	if body.is_in_group("container"):
		for i in body.containedObjects:
			boxesInTruck.append(i)
	incomeRef.update()
	weightRef.update()
	updateCapacity(-boxVolume / truckVolume, "entered")
	updateScore(boxScore)
	player.totalScore = TotalScore
	
	if body.has_method("WhenloadedAbility"):
		body.WhenloadedAbility()
	var NumberOfBoxesWithOLAbility:int = 0
	stats.objectsLoaded += 1
	for i in boxesInTruck:
		var boxTracking = str(i.get_instance_id()) + "_" + str(body.get_instance_id())
		if i.has_method("otherBoxLoadedAbility") and not alreadyBeen.has(boxTracking) and not boxesInTruckInContainer.has(i):
			NumberOfBoxesWithOLAbility += 1
			i.otherBoxLoadedAbility(body)
			alreadyBeen.append(boxTracking)
	print("Number Of Boxes With OL Ability is " + str(NumberOfBoxesWithOLAbility))
	print(alreadyBeen.has(body))
	print("boxes still in world" + str(boxesInTruck.size() - get_tree().get_nodes_in_group("boxes").size()))
	if remainingCapacity < capacityNeededTooLeave or weightRef.WeightLeft <= 0 or boxesInTruck.size() == get_tree().get_nodes_in_group("boxes").size():
		print("remainingCapacity is" + str(remainingCapacity))
		print("capacityNeededTooLeave is" + str(capacityNeededTooLeave))
		print("truckTextUpdate2.WeightLeft is" + str(weightRef.WeightLeft))
		print("boxesInTruck.size() is" + str(boxesInTruck.size()))
		print("number of boxes in group is " + str(get_tree().get_nodes_in_group("boxes").size()))
		isleaving = true
		await LeavingPath.loadingEnded()

func _on_area_3d_body_exited(body: Node3D) -> void:

	boxVolume = getBoxVolume(body)
	boxScore = getBoxScore(body)
	if truckVolume <= 0.0 or boxVolume <= 0.0:
		return
	if body in boxesInTruck:
		boxesInTruck.erase(body)
	updateCapacity(boxVolume / truckVolume, "exited")
	updateScore((boxScore))
	incomeRef.update()
	weightRef.update()
	stats.objectsUnloaded += 1
	if body.is_in_group("player") or body.is_in_group("truck"):
		return
	
