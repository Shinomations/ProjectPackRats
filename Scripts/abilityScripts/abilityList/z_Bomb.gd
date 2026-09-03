extends CharacterBody3D

# Called when the node enters the scene tree for the first time.
@onready var boxbasic1 = $CollisionShape3D

var GivenName = "Bag with a BOMBS"
var GivenWeight = 60
var GivenType = "Bag"
var GivenIncome = 500
var GivenAbility = "Quest Completed: Explode and Destroy all boxes around this one, if this is destroyed first, add 100 income to all boxes around this"
var GivenHealth = 40

var selected = false
var player
var outlineWidth = 0.05
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var size: Vector2 = Vector2(2,2)
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
	add_to_group("boxes")

func _process(_delta):
	
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
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	var boxCounter: int = 0
	
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject and body.GivenName != "Box With Anvils":
			if body.canBeDestroyed == true:
				if boxCounter == 5:
					if "Destroyer" in body and body.canBeDestroyed:
						body.Destroyer = self
						body.ability()
					body.queue_free()
	pass # Replace with function body.

func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)
