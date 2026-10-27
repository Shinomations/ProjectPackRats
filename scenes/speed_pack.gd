extends Node3D

var speedPackIncomeTotal: int = 0
@onready var itemMarker = $Area3D/ItemMarker3D
@onready var no = $Area3D/NotItemMarker3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("items"):
		body.set_deferred("global_position", no.global_position)
	else:
		if body.has_method("SpeedpackAbility"):
			body.SpeedpackAbility()
		speedPackIncomeTotal += body.GivenIncome
		await get_tree().process_frame
		body.queue_free()
