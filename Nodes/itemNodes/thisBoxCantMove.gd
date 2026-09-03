extends Area3D

@onready var parent = $".."

func _on_body_entered(body: Node3D) -> void:
	parent.isPickUpable = false
