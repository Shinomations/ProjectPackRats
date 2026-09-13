extends CharacterBody3D

@onready var boxbasic1 = $CollisionShape3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D

var GivenName = "Box of Wires"
var GivenWeight = 25
var GivenType = "Cardboard"
var GivenIncome = 200
var GivenAbility = "When Destroyed: Double the Income of the Box that destroyed this"
var GivenHealth = 50
var tier = 3

var selected = false
var player
var outlineWidth = 0.05
var height = 1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var size: Vector2 = Vector2(1,1)
@export var offset: Vector3 = Vector3.ZERO
var Destroyer

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
	
	
	
func ability() -> void:
	Destroyer.GivenIncome *= 2
	

func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)
