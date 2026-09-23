extends BaseBox

var surroundingBoxes: Array[Node3D] = []


func _init() -> void:
	GivenName = "Anvil"
	GivenWeight = 1000
	GivenType = "Wooden"
	GivenIncome = 1000
	GivenAbility = "This Heavy AF"
	GivenHealth = 500
	height = 2
	size = Vector2(2,2)
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
				squashTween.tween_property(mesh2Animate,"scale", Vector3(2.7,1.1,0.7), 1)
				gpu_particles_3d.emitting = false
		
	elif is_on_floor() and gravity > 0 and not splatted:
		splatted = true
		if squashTween and squashTween.is_running():
			squashTween.kill()
		squashTween = create_tween()
		squashTween.tween_property(mesh2Animate,"scale", Vector3(3.3,0.5,1.3), 0.1)
		squashTween.tween_property(mesh2Animate,"scale", Vector3(3,1,1), 0.2)
		gpu_particles_3d.emitting = true
		velocity.y = 0
		
	if gravity < 0 and not is_on_ceiling():
		velocity.y -= gravity * delta
	elif is_on_ceiling() and gravity < 0:
		velocity.y = 0
	move_and_slide()

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		surroundingBoxes.append(body)

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and surroundingBoxes.has(body):
		surroundingBoxes.erase(body)

func MergeAbility() -> void:
	for i in surroundingBoxes:
		if is_instance_valid(i) and "GivenWeight" in i:
			i.GivenWeight -= 100
			
	surroundingBoxes.clear()
