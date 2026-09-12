extends CharacterBody3D

#calling of children
@onready var boxbasic1 = $CollisionShape3D
@onready var area = $Area3D

#Per box Stats
var GivenName = "Drink Pallete"
var GivenWeight = 400
var GivenType = "Wooden"
var GivenIncome = 300
var GivenAbility = "Passive: All boxes above this have +100 income"
var GivenHealth = 500
var tier = 5

#all box variables
var selected = false
var player
var outlineWidth = 0.05
var uses = 0
var height = 1
#box specific variables
var bodies
var gravity = 9.8
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
func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("boxes")
	safe_margin = 0.0005
	
	for child in get_children():
		child.position -= offset


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
		
	elif is_on_floor() and gravity > 0:
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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		body.GivenIncome += 100
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes"):
		body.GivenIncome -= 100
