extends CharacterBody3D


#calling of children
@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $MeshInstance3D2
@onready var area = $Area3D


#Per box Stats
var GivenName = "Box With Anvils"
var GivenWeight = 500
var GivenType = "Wooden"
var GivenIncome = 1000
var GivenAbility = "First Placement: Destroy everything underneath this (Not other Anvil boxes)"
var GivenHealth = 100

#all box variables
var selected = false
var player
var outlineWidth = 0.05


#box specific variables
var bodies
var gravity = 9.8
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

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.interact_object.connect(_set_selected)
	add_to_group("boxes")
	meshOutline.visible = false
	
	for child in get_children():
		child.position -= offset

func _process(_delta):
	
	meshOutline.visible = selected and not player == get_parent()
	
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
		 
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		
	move_and_slide()


func _set_selected(object):
	selected = self == object
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body == self or body.is_in_group("player"):
		return
		
	if player.pickedObject == self:
		return
	
	if "GivenName" in body:
		if body.GivenName == "Box With Anvils":
			return 
			
		
		var dynamic_can_destroy = body.get("canBeDestroyed") if "canBeDestroyed" in body else true
		
		if dynamic_can_destroy:
			if "Destroyer" in body:
				body.Destroyer = self
				if body.has_method("ability"):
					body.ability()
			
			body.queue_free()


func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)
