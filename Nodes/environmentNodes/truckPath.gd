extends Path3D

@export var path_follow_3d: PathFollow3D
@export var truck: Area3D
func loadingEnded():
	truck.body_entered.disconnect(truck._on_body_entered)
	var tween = create_tween()
	for i in truck.boxesInTruck:
			i.reparent(truck)
	
	tween.tween_property(path_follow_3d, "progress_ratio", 1.0, 3.0)
	
	await tween.finished
	
	truck.player.FinalScore += truck.player.totalScore
	truck.player.totalScore = 0
	
	for i in truck.get_children():
		if i.is_in_group("boxes"):
			i.remove_from_group("boxes")
			i.queue_free()
		
	path_follow_3d.progress_ratio = 0.0
	truck.player.areThereStillBoxes()
	var return_tween = create_tween()
	return_tween.tween_property(path_follow_3d, "progress_ratio", 0.4, 2.0)
	truck.body_entered.connect(truck._on_body_entered)
