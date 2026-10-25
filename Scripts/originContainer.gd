extends CharacterBody3D
class_name Contain

#particle preloads
var particleInstance
@onready var particleParent = $Node3D
@export var allParticles: Dictionary[String, PackedScene] = {
	"Place": null,
	"Destroyed": null,
	"Income": null,
	"PIncome": null,
	"Health": null,
	"PHealth": null,
	"Weight": null,
	"PWeight": null,
	"Use": null
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
var stats
var outlineWidth = 0.05
var height = 1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var size: Vector3 = scale
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
var hasRun: bool = false
var isThrowable: bool = false
var throwDirection: Vector3 = Vector3.ONE
var velocityChanger: Vector3 = Vector3.ZERO
var floatingTime: int = 0
#container specific variables
var containedObjects: Array[CharacterBody3D] = []
@onready var containerParent = $ContainerPositions
var slotsToPutItemIn: int = 0
var slotsFilled: bool = false
var hasSomething: bool = false
var selfref = self

func _ready():
	player = get_tree().get_first_node_in_group("player")
	speedPack = get_tree().get_first_node_in_group("speedPack")
	truck = get_tree().get_first_node_in_group("truck")
	stats = get_tree().get_first_node_in_group("GlobalStats")
	print(GivenName)
	add_to_group("boxes")
	slotsToPutItemIn = containerParent.get_child_count() - containerParent.get_child_count()
	
	if selfref.has_method("randomized"):
		selfref.randomized()
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
		
	if truck.boxesInTruck.has(self) and (GivenHealth <= 0 or CollectedWeight >= GivenWeight * 4):
		stats.objectsDestroyed += 1
		print(stats.objectsDestroyed)
		self.queue_free()
func _physics_process(delta: float) -> void:
	if player.pickedObject == self:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	if not is_on_floor():
		var applied_gravity = gravity
		if velocityChanger.y < 0:
			applied_gravity *= 2.0
		
		velocityChanger.y -= applied_gravity * delta
		if gravity < 0 and is_on_ceiling():
			velocityChanger.y = 0

	velocity = velocityChanger
	move_and_slide()

	var hitFloor = is_on_floor()
	if not hitFloor and velocityChanger.y < 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_normal().dot(Vector3.UP) > 0.7:
				hitFloor = true
				break

	if not hitFloor and gravity > 0:
		if splatted:
			splatted = false
			if squashTween == null or not squashTween.is_running():
				squashTween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
				squashTween.tween_property(self, "scale", FallingSquash * size, 1.0)

	elif hitFloor and gravity > 0 and not splatted:
		splatted = true
		floatingTime = 0
		isThrowable = true
		velocityChanger = Vector3.ZERO
		velocity = Vector3.ZERO
		
		if squashTween and squashTween.is_running():
			squashTween.kill()
		squashTween = create_tween()
		squashTween.tween_property(self, "scale", landingSquash * size, 0.1)
		squashTween.tween_property(self, "scale", EndSquash * size, 0.2)
		emitParticles("Place", global_position)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		isPickUpable = false
		boxesAboveThis.append(body)
	

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and boxesAboveThis.has(body):
		boxesAboveThis.erase(body)

	if boxesAboveThis.is_empty():
		isPickUpable = true


func emitParticles(particleByName: String,startPosition: Vector3):
	if particleByName == "" or not allParticles.has(particleByName) and allParticles.find_key(null):
		print("doesnt have particle")
		return
	particleInstance = null
	var particleScene: PackedScene = allParticles[particleByName]
	if not particleScene:
		return
	particleInstance = particleScene.instantiate()
	
	particleParent.add_child(particleInstance)
	particleInstance.global_position = startPosition
	
	particleInstance.emitting = true
	
	if particleInstance.one_shot:
		particleInstance.finished.connect(particleInstance.queue_free)


func statHandler(Stat2Change: String,Amount: int = 0,Passiveness: int = 0):
	print_rich( "[color=green] Name: " + GivenName)
	print_rich( "[color=green] Type: " + GivenType)
	print_rich( "[color=green] Weight: " + str(GivenWeight))
	print_rich( "[color=green] Income: " + str(GivenIncome))
	print_rich( "[color=green] Health: " + str(GivenHealth))

	#0 = off
	#1 = 1 time permanent income
	#2 = passive
	if Passiveness == 1:
		emitParticles(Stat2Change,global_position)
	elif Passiveness == 2:
		emitParticles("P"+Stat2Change,global_position)
	elif Passiveness == 0:
		if is_instance_valid(particleParent):
			for i in particleParent.get_children():
				i.queue_free()
		return
	var stat = "Given" + Stat2Change
	print_rich( "[color=red] Changing stat is " + Stat2Change)
	print_rich( "[color=red] Amount It should change is" + str(Amount))

	set(stat,get(stat) + Amount)

	print_rich( "[color=pink] Name: " + GivenName)
	print_rich( "[color=pink] Type: " + GivenType)
	print_rich( "[color=pink] Weight: " + str(GivenWeight))
	print_rich( "[color=pink] Income: " + str(GivenIncome))
	print_rich( "[color=pink] Health: " + str(GivenHealth))

func changeableAbility():
	pass

func contain(body):
	if body.is_in_group("container"):
		return
	hasSomething = true
	print("Available Slot is " + str(slotsToPutItemIn))
	containedObjects.append(body)
	var slot = containerParent.get_child(slotsToPutItemIn)
	body.reparent(slot)
	body.global_position = slot.global_position
	body.scale = scale/3.3
	
	body.set_physics_process(false)
	body.set_collision_layer_value(1,false)
	body.set_collision_layer_value(3,false)
	player._toggleCollision(body, true)
	
	if player.pickedObject == body:
		player.collisionSet(false)

	GivenHealth += body.GivenHealth
	GivenIncome += body.GivenIncome
	GivenWeight += body.GivenWeight
	if containerParent.get_child_count() - 1 > slotsToPutItemIn:
		slotsToPutItemIn += 1  
		
func take():
	if not containedObjects.is_empty() and slotsToPutItemIn >= 0 and (slotsFilled or player.pickedObject == null):
		var objectToTakeOut
		objectToTakeOut = containerParent.get_child(slotsToPutItemIn - 1).get_child(0)
		slotsToPutItemIn -= 1
		objectToTakeOut.isPickUpable = true
		objectToTakeOut.set_collision_layer_value(1,true)
		objectToTakeOut.set_collision_layer_value(3,true)
		GivenHealth -= objectToTakeOut.GivenHealth
		GivenIncome -= objectToTakeOut.GivenIncome
		GivenWeight -= objectToTakeOut.GivenWeight
		objectToTakeOut.set_physics_process(true)
		containedObjects.erase(objectToTakeOut)
		if slotsToPutItemIn == 0:
			hasSomething = false
		player.pick_up_object(objectToTakeOut)
			
func throw(direction: Vector3, speed: float):
	
	throwDirection = direction
	velocityChanger = direction.normalized() * speed
	isThrowable = false
	print(velocityChanger)
	pass
