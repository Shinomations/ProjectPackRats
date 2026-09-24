extends Path3D

@export var path_follow_3d: PathFollow3D
@export var truck: Area3D
var tween: Tween
var stopPosition = 0.4
var hadToStop: bool = false
		
func loadingEnded():
	if path_follow_3d:
		path_follow_3d.progress_ratio = stopPosition
	
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
	
	tween = create_tween()
	tween.tween_property(path_follow_3d, "progress_ratio", 1.4, 5.0)
	
	await tween.finished
	
	if not truck.body_entered.is_connected(truck._on_body_entered):
		truck.body_entered.connect(truck._on_body_entered)
	if not truck.body_exited.is_connected(truck._on_body_exited):
		truck.body_exited.connect(truck._on_body_exited)
	
	stopPosition = 0.4
	
	truck.player.areThereStillBoxes()
