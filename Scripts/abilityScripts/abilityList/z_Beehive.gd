extends CharacterBody3D

@onready var boxbasic1 = $CollisionShape3D
const honey = preload("res://Nodes/itemNodes/i_jarOfHoney.tscn")

var GivenName = "Beehive"
var GivenWeight = 45
var GivenType = "Organic"
var GivenIncome = 100
var GivenAbility = "When another ORGANIC unit is loaded: add a JAR OF HONEY to the speed pack"
var GivenHealth = 75
var tier = 1

var selected = false
var player
var speedPack
var outlineWidth = 0.05
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
var height = 1
func _ready():
	player = get_tree().get_first_node_in_group("player")
	speedPack = get_tree().get_first_node_in_group("speedPack")
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
		GivenHealth = 10

func _set_selected(object):
	selected = self == object
	

func _physics_process(delta):
		
	if player.pickedObject == self:
		velocity = Vector3.ZERO
		 
	if not is_on_floor() and gravity > 0:
		velocity.y -= gravity * delta
		
	elif is_on_floor() and gravity > 0:
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
	
	var honeySpawn = honey.instantiate()
	
	speedPack.itemMarker.add_child(honeySpawn)
	get_tree().current_scene.add_child(honeySpawn)
	
