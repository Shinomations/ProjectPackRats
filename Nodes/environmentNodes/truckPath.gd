extends Path3D

@export var path_follow_3d: PathFollow3D
@export var truck: CharacterBody3D
var tween: Tween
var stopPosition = 0.4
var hadToStop: bool = false
var player
var client

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func loadingEnded():
	
	if not client:
		client = get_tree().get_first_node_in_group("clients")
		
	if client.has_method("beforeAbility"):
		client.beforeAbility()
	
	if path_follow_3d:
		path_follow_3d.progress_ratio = stopPosition
	
	player.FinalScore += player.totalScore
	truck.remainingCapacity = 1.0
	player.totalScore = 0
	
	for i in truck.boxesInTruck:
		print(i)
		if i.is_in_group("boxes"):
			i.remove_from_group("boxes")
			i.queue_free()
			
	truck.boxesInTruck.clear()
	
	tween = create_tween()
	tween.tween_property(path_follow_3d, "progress_ratio", 1.4, 5.0)
	
	await tween.finished
	
	stopPosition = 0.4
	
	player.areThereStillBoxes()
	if client.has_method("afterAbility"):
		client.afterAbility(7)
