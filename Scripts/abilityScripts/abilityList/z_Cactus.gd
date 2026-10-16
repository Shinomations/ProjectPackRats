extends BaseBox

var surroundingBooster: Array = []
var alreadyHit: Array = []
func _init() -> void:
	GivenName = "Cactus"
	GivenWeight = 150
	GivenType = "Organic"
	GivenIncome = 100
	GivenAbility = "For each adjacent Organic Unit this deals +10 damage to units placed next to this that arent Organic "
	GivenHealth = 150
	height = 2
	size = Vector3(1,1,2)
	canBeDestroyed = true
	

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if not body.is_in_group("boxes"):
		return
	if body.GivenType == "Organic" and not body == self:
		surroundingBooster.append(body)
		return
	
	for i in surroundingBooster:
		body.GivenHealth -= 10
		alreadyHit.append(body)
	

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if surroundingBooster.has(body):
		surroundingBooster.erase(body)
