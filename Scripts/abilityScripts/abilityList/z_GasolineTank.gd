extends CharacterBody3D

#calling of children
@onready var boxbasic1 = $CollisionShape3D
@onready var viableSpots = $Areas
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

#Per box Stats
var boxesLeft

var GivenName = "Gasoline Tank"
var GivenWeight = 500
var GivenType = "Plastic"
var GivenIncome = 450
var GivenAbility = "If this is completely covered \n Double this units Income and half its Weight"
var GivenHealth = 250
var tier = 4

#all box variables
var selected = false
var player
var truck
var outlineWidth = 0.05
var uses = 0
var height = 2
#box specific variables
var bodies
var gravity = 9.8
@export var size: Vector2 = Vector2(1,2)
@export var offset: Vector3 = Vector3.ZERO

var clearedAreas: Array = []
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
func _ready():
	player = get_tree().get_first_node_in_group("player")
	truck = get_tree().get_first_node_in_group("truck")
	add_to_group("boxes")
	safe_margin = 0.0005

	
	boxesLeft = viableSpots.get_child_count()

func _process(_delta):
	if GivenWeight < 0:
		gravity = -9.8
		set_physics_process(true)
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
		 
	if not is_on_floor() and gravity > 0:
		velocity.y -= gravity * delta
		gpu_particles_3d.emitting = false
	elif is_on_floor() and gravity > 0:
		gpu_particles_3d.emitting = true
		velocity.y = 0
		set_physics_process(false)
	
	if gravity < 0 and not is_on_ceiling():
		velocity.y -= gravity * delta
	elif is_on_ceiling() and gravity < 0:
		velocity.y = 0
		set_physics_process(false)
	move_and_slide()
func _set_selected(object):
	
	selected = self == object
func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)

func ability():
	if not truck:
		return
	if not truck.boxesInTruck.has(self):
		return
		
	bodies = viableSpots.get_children()
	
	var filledSlotsCount = 0
	var totalSlotsCount = 0
	
	for i in bodies:
		if i is Area3D:
			totalSlotsCount += 1
			var Overlappers = i.get_overlapping_bodies()
			
			var slotIsOccupied = false
			for body in Overlappers:
				if body != player and body != self:
					slotIsOccupied = true
					break 
			
			if slotIsOccupied:
				filledSlotsCount += 1

	var newBoxesLeft = totalSlotsCount - filledSlotsCount
	
	if newBoxesLeft != boxesLeft:
		boxesLeft = newBoxesLeft
		print("Spots covered: " + str(filledSlotsCount) + "/" + str(totalSlotsCount))

	if boxesLeft == 0 and not usedAbility:
		GivenWeight /= 2
		GivenIncome *= 2
		usedAbility = true
		print("ACHIEVED: Box is 100% surrounded and covered!")
		
	elif boxesLeft > 0 and usedAbility:
		GivenWeight *= 2
		GivenIncome /= 2
		usedAbility = false
		print("LOST COVERAGE: A spot was uncovered.")
