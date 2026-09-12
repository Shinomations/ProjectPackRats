extends Node3D

var speedPackIncomeTotal: int = 0
@onready var itemMarker = $ItemMarker3D
@onready var no = $NotItemMarker3D

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("items") and body:
		body.set_deferred("global_position", no.global_position)
	else:
		speedPackIncomeTotal += body.GivenIncome
		body.queue_free()
