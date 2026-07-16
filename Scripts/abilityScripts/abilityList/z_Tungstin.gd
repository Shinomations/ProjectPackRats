extends CharacterBody3D


# Called when the node enters the scene tree for the first time.

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $CollisionShape3D/MeshInstance3D

var GivenName = "Tungstin"
var GivenWeight = 100
var GivenType = "Metal"
var GivenIncome = 250
var GivenAbility = "Passive:This cant be destroyed"
var GivenHealth = 50

var scaling = 1.1

var selected = false
var player
var outlineWidth = 0.05
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Ability Specific editing

var canBeDestroyed: bool = false
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
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
	
