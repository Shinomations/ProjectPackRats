extends BaseBox
var bodiesBelow = []
var abilityUsed: bool = false
func _init() -> void:
	GivenName = "Beacon"
	GivenWeight = 300
	GivenType = "Metal"
	GivenIncome = 10
	GivenAbility = "Have exactly 9 Units under this -> all boxes in the truck get +100 income"
	GivenHealth = 500
	height = 2
	size = Vector3(2,2,2)
	canBeDestroyed = true

func _process(_delta):
	super(_delta)
	if bodiesBelow.size() >= 9 and not abilityUsed:
		for i in truck.boxesInTruck:
			i.GivenIncome += 100
		abilityUsed = true
func _on_b_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_3_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_4_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_5_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_6_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_7_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_8_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)
func _on_b_9_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		bodiesBelow.append(body)

func _on_b_1_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_2_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_3_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_4_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_5_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_6_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_7_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_8_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
func _on_b_9_body_exited(body: Node3D) -> void:
	if bodiesBelow.has(body):
		bodiesBelow.erase(body)
