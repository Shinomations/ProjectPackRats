extends Path3D

@export var path_follow_3d: PathFollow3D
@export var truck: Area3D
func loadingEnded():
	truck.player.FinalScore += truck.player.totalScore
	truck.remainingCapacity = 1.0
	truck.player.totalScore = 0
	
	if truck.body_entered.is_connected(truck._on_body_entered):
		truck.body_entered.disconnect(truck._on_body_entered)
	if truck.body_exited.is_connected(truck._on_body_exited):
		truck.body_exited.disconnect(truck._on_body_exited)
	
	for i in truck.boxesInTruck:
		if i.is_in_group("boxes"):
			i.remove_from_group("boxes")
			i.queue_free()
			
	truck.boxesInTruck.clear()
	
	var tween = create_tween()
	tween.set_loops(1)
	
	tween.tween_property(path_follow_3d, "progress_ratio", 1.0, 3.0)
	tween.tween_property(path_follow_3d, "progress_ratio", 0.4, 3.0)
	
	await tween.finished
	
	if not truck.body_entered.is_connected(truck._on_body_entered):
		truck.body_entered.connect(truck._on_body_entered)
	if not truck.body_exited.is_connected(truck._on_body_exited):
		truck.body_exited.connect(truck._on_body_exited)
	
	truck.player.areThereStillBoxes()
