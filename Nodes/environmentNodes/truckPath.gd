extends Path3D

@export var path_follow_3d: PathFollow3D
@export var truck: Area3D
func loadingEnded():
	truck.player.FinalScore += truck.player.totalScore
	truck.remainingCapacity = 1
	truck.player.totalScore = 0
	truck.body_entered.disconnect(truck._on_body_entered)
	
	for i in truck.boxesInTruck:
		if i.is_in_group("boxes"):
			i.remove_from_group("boxes")
			i.queue_free()
			
	var tween = create_tween()
	tween.set_loops(1)
	
	tween.tween_property(path_follow_3d, "progress_ratio", 1.0, 3.0)
	tween.tween_property(path_follow_3d, "progress_ratio", 0.4, 3.0)
	
	await tween.finished
	
	truck.player.areThereStillBoxes()
