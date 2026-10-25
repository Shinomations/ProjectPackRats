extends BaseBox
var velocityHold: Vector3 = Vector3.ZERO
var velocityUse: Vector3 = Vector3.ZERO
func _init() -> void:
	GivenName = "Box of Glassware"
	GivenWeight = 200
	GivenType = "Cardboard"
	GivenIncome = 550
	GivenAbility = "If anything is placed above this, destroy this"
	GivenHealth = 50
	height = 1
	canBeDestroyed = true
	
func _process(_delta):
	super(_delta)

	if velocityHold.y <= -7.5 and is_on_floor():
		queue_free()
	velocityHold = velocity
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject and truck.boxesInTruck.has(self):
			self.queue_free()
