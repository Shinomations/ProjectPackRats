extends CharacterBody3D

#calling of children
@onready var boxbasic1 = $CollisionShape3D
@onready var area = $Area3D
@onready var globalLocal = $placementmarker
#Per box Stats
var GivenName = "Box With Anvils"
var GivenWeight = 500
var GivenType = "Wooden"
var GivenIncome = 1000
var GivenAbility = "First Placement: Destroy everything underneath this (Not other Anvil boxes)"
var GivenHealth = 100
var tier = 5
#all box variables
var selected = false
var player
var outlineWidth = 0.05
var uses = 0
var height = 2
#box specific variables
var bodies
var gravity = 9.8
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

@export var size: Vector2 = Vector2(1,2)
@export var offset: Vector3 = Vector3.ZERO

#Ability Specific editing
var canBeDestroyed: bool = true
var incomeCanChange:bool = true
var weightCanChange:bool = true
var healthCanChange:bool = true
var abilityCanChange:bool = true
var materialCanChange:bool = true
var canBeMoved:bool = true
var canMove:bool = true
var canReroll:bool = true

var isPickUpable:bool = true
var usedAbility: bool = false
var squashTween: Tween = null
var splatted: bool = false
func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("boxes")
	safe_margin = 0.0005
	



func _process(_delta):
	if GivenWeight < 0:
		gravity = -9.8
	else:
		gravity = 9.8
	
	if selected:
		boxbasic1.position.y = outlineWidth
		player.boxTypeDetector = 1 
	else:
		boxbasic1.position.y = 0
		
	if GivenHealth <= 0:
		self.queue_free()
func _physics_process(delta: float) -> void:
	
	if player.pickedObject == self:
		velocity = Vector3.ZERO
		move_and_slide()
		return
		 
	if not is_on_floor() and gravity > 0:
		velocity.y -= gravity * delta
		splatted = false
		if squashTween == null or not squashTween.is_running():
			squashTween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			squashTween.tween_property(self,"scale", Vector3(0.8,1.2,0.8), 1)
			gpu_particles_3d.emitting = false
		
	elif is_on_floor() and gravity > 0:
		if not splatted:
			splatted = true
			if squashTween:
				squashTween.kill()
			squashTween = create_tween()
			squashTween.tween_property(self,"scale", Vector3(1.3,0.5,1.3), 0.1)
			squashTween.tween_property(self,"scale", Vector3(1,1,1), 0.2)
			gpu_particles_3d.emitting = true
		velocity.y = 0
		

	if gravity < 0 and not is_on_ceiling():
		velocity.y -= gravity * delta
	elif is_on_ceiling() and gravity < 0:
		velocity.y = 0
	move_and_slide()


func _set_selected(object):
	
	selected = self == object
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	

	if body == self or body.is_in_group("player") or player.pickedObject == self:
		return

	if "GivenName" in body:
		if body.GivenName == "Box With Anvils":
			return 
			

		var dynamic_can_destroy = body.get("canBeDestroyed") if "canBeDestroyed" in body else true
		
		if dynamic_can_destroy:
			if "Destroyer" in body:
				body.Destroyer = self
				if body.has_method("ability"):
					body.ability()
					
			
			body.queue_free()
			usedAbility = true


func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)
