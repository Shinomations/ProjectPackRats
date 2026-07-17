extends CharacterBody3D


# Called when the node enters the scene tree for the first time.

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $MeshInstance3D

var GivenName = "Box of Wires"
var GivenWeight = 25
var GivenType = "Cardboard"
var GivenIncome = 200
var GivenAbility = "When Destroyed: Double the Income of the Box that destroyed this"
var GivenHealth = 50

var selected = false
var player
var outlineWidth = 0.05
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var size: Vector2 = Vector2(2,2)
@export var offset: Vector3 = Vector3.ZERO
var Destroyer

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

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.interact_object.connect(_set_selected)
	
	meshOutline.visible = false

func _process(_delta):
	
	meshOutline.visible = selected and not player == get_parent()
	
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
	# Add the gravity to velocity each frame if not on the floor
	if player.pickedObject == self:
		velocity = Vector3.ZERO
		 
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		
	move_and_slide()
	
	
	
func ability() -> void:
	Destroyer.GivenIncome *= 2
	

func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)
