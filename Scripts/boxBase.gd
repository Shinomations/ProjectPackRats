extends CharacterBody3D
class_name BaseBox

#particle preloads
var particleInstance
@onready var particleParent = $Node3D
@export var allParticles: Dictionary[String, PackedScene] = {
	"Place": null,
	"Destroyed": null,
	"Income+": null,
	"Passive Income+": null,
	"Health+": null,
	"Passive Health+": null,
	"Weight+": null,
	"Passive Weight+": null
}

#shared references
@onready var boxbasic1 = $CollisionShape3D
@onready var mesh2Animate = $CollisionShape3D/MeshInstance3D

#overwritable by new box
var GivenName = "Generic box"
var GivenWeight = 0
var GivenType = "Cardboard"
var GivenIncome = 0
var GivenAbility = "What should this do"
var GivenHealth = 100
@export var FallingSquash: Vector3 = Vector3(0.7,1.1,0.7)
@export var landingSquash: Vector3 = Vector3(1.3,0.5,1.3)
@export var EndSquash: Vector3 = Vector3(1.0,1.0,1.0)
#shared variables
var CollectedWeight = 0
var selected = false
var player
var speedPack
var truck
var outlineWidth = 0.05
var height = 1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var size: Vector2 = Vector2(1,1)
@export var offset: Vector3 = Vector3.ZERO
var squashTween: Tween = null
var splatted: bool = false
var boxesAboveThis: Array[Node3D] = []

#ability toggles
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

func _ready():
	player = get_tree().get_first_node_in_group("player")
	speedPack = get_tree().get_first_node_in_group("speedPack")
	truck = get_tree().get_first_node_in_group("truck")

	add_to_group("boxes")
func _process(_delta):
	CollectedWeight = 0
	
	for i in boxesAboveThis:
		CollectedWeight += i.GivenWeight + i.CollectedWeight
	
	
	if GivenWeight < 0:
		gravity = -9.8
	else:
		gravity = 9.8

	if selected:
		boxbasic1.position.y = outlineWidth
		player.boxTypeDetector = 1 
	else:
		boxbasic1.position.y = 0
		
	if GivenHealth <= 0 or CollectedWeight >= GivenWeight * 4:
		self.queue_free()
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
				squashTween.tween_property(mesh2Animate,"scale", FallingSquash, 1)
				
		
	elif is_on_floor() and gravity > 0 and not splatted:
		splatted = true
		if squashTween and squashTween.is_running():
			squashTween.kill()
		squashTween = create_tween()
		squashTween.tween_property(mesh2Animate,"scale", landingSquash, 0.1)
		squashTween.tween_property(mesh2Animate,"scale", EndSquash, 0.2)
		emitParticles("Place",global_position)
		velocity.y = 0
		
	if gravity < 0 and not is_on_ceiling():
		velocity.y -= gravity * delta
	elif is_on_ceiling() and gravity < 0:
		velocity.y = 0
	move_and_slide()
func _set_selected(object):
	selected = self == object
	
func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		boxesAboveThis.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and boxesAboveThis.has(body):
		boxesAboveThis.erase(body)

func emitParticles(particleByName: String,startPosition: Vector3):
	if not allParticles.has(particleByName) and not particleByName:
		print("doesnt have particle")
		return
	particleInstance = null
	var particleScene: PackedScene = allParticles[particleByName]
	print(str(GivenName) + str(particleScene))
	particleInstance = particleScene.instantiate()
	
	particleParent.add_child(particleInstance)
	particleInstance.global_position = startPosition
	
	particleInstance.emitting = true
	
	if particleInstance.one_shot:
		particleInstance.finished.connect(particleInstance.queue_free)


func incomeHandler(Amount: int = 0,Passiveness: int = 0):
	#0 = off
	#1 = 1 time permanent income
	#2 = passive
	if Passiveness == 1:
		emitParticles("Income+",global_position)
	elif Passiveness == 2:
		emitParticles("Passive Income+",global_position)
	elif Passiveness == 0:
		if is_instance_valid(particleParent):
			for i in particleParent.get_children():
				i.queue_free()
		return
	GivenIncome += Amount
