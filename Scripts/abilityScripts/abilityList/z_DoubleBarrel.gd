extends BaseBox

var surroundingBoxes: Array[Node3D] = []
var shots: int = 2

func _init() -> void:
	GivenName = "Shotgun case"
	GivenWeight = 75
	GivenType = "Plastic"
	GivenIncome = 100
	GivenAbility = "When Merge with: Shoot 2 shots at surrounding boxes give them -50 weight"
	GivenHealth = 100
	height = 1
	size = Vector2(1,1)
	canBeDestroyed = true
	
func _physics_process(delta: float) -> void:
	if player.pickedObject == self:
		velocity = Vector3.ZERO
		move_and_slide()
		return
		 
	if not is_on_floor() and gravity > 0:
		velocity.y -= gravity * delta
		if splatted:
			splatted = false
			if squashTween == null or not squashTween.is_running():
				squashTween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
				squashTween.tween_property(mesh2Animate,"scale", Vector3(1.7,1.1,0.7), 1)
				gpu_particles_3d.emitting = false
		
	elif is_on_floor() and gravity > 0 and not splatted:
		splatted = true
		if squashTween and squashTween.is_running():
			squashTween.kill()
		squashTween = create_tween()
		squashTween.tween_property(mesh2Animate,"scale", Vector3(2.3,0.5,1.3), 0.1)
		squashTween.tween_property(mesh2Animate,"scale", Vector3(2,1,1), 0.2)
		gpu_particles_3d.emitting = true
		velocity.y = 0
		
	if gravity < 0 and not is_on_ceiling():
		velocity.y -= gravity * delta
	elif is_on_ceiling() and gravity < 0:
		velocity.y = 0
	move_and_slide()
func MergeAbility():
	var rnd
	var picked:Array = []
	for i in shots:
		if not surroundingBoxes.is_empty():
			rnd = surroundingBoxes.pick_random()
			picked.append(rnd)
		else:
			picked.append(self)
	for i in picked:
		if shots > 0:
			i.GivenWeight -= 50
			shots -= 1
	surroundingBoxes = []
	shots = 2
