extends CharacterBody3D


# Called when the node enters the scene tree for the first time.

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $CollisionShape3D/MeshInstance3D2
@onready var area = $CollisionShape3D/Area3D
var GivenName = "Box With Anvils"
var GivenWeight = 500
var GivenType = "Wooden"
var GivenIncome = 1000
var GivenAbility = "First Placement: Destroy everything underneath this (Not other Anvil boxes)"
var GivenHealth = 100

var scaling = 1.1

var selected = false
var player
var outlineWidth = 0.05

#ability specific variables
var bodies
var gravity = 9.8

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
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0 
	move_and_slide()


func _set_selected(object):
	selected = self == object
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject and body.GivenName != "Box With Anvils":
			if "Destroyer" in body:
				body.Destroyer = self
				body.ability()
			body.queue_free()
