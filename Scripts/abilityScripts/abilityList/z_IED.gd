extends CharacterBody3D

# Called when the node enters the scene tree for the first time.
@onready var boxbasic1 = $CollisionShape3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

var timer = 1

var GivenName = "IED"
var GivenWeight = 60
var GivenType = "Bag"
var GivenIncome = 200
var GivenAbility = "Destroy the next thing loaded"
var GivenHealth = 40
var tier = 2

var selected = false
var player
var truck
var outlineWidth = 0.05
var height = 1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var size: Vector2 = Vector2(1,1)
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
func _ready():
	player = get_tree().get_first_node_in_group("player")
	truck = get_tree().get_first_node_in_group("truck")
	add_to_group("boxes")


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

func _set_selected(object):
	selected = self == object
	

func _physics_process(delta):
		
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

func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)

func TruckEnterAbilityability():
	if truck.boxesInTruck.has(self):
		if timer == 0:
			var dynamic_can_destroy = truck.bodySelected.get("canBeDestroyed") if "canBeDestroyed" in truck.bodySelected else true
			print(dynamic_can_destroy)
			if dynamic_can_destroy:
				if "Destroyer" in truck.bodySelected:
					truck.bodySelected.Destroyer = self
					if truck.bodySelected.has_method("ability"):
						truck.bodySelected.ability()
				truck.bodySelected.queue_free()
		timer -= 1
	
