extends CharacterBody3D


# Called when the node enters the scene tree for the first time.

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $CollisionShape3D/MeshInstance3D

var GivenName = "Box of Nails"
var GivenWeight = 20
var GivenType = "Cardboard"
var GivenIncome = 200
var GivenAbility = "Passive: Deal 10 Damage to all boxes directly adjacent to this by "
var GivenHealth = 10

var scaling = 1.1

var selected = false
var player
var outlineWidth = 0.05
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var BoxesNotToAffect: Array = []
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
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject:
			if not BoxesNotToAffect.has(body):
				body.GivenHealth -= 10
				BoxesNotToAffect.append(body)
				print(BoxesNotToAffect)
				if "Destroyer" in body and body.GivenHealth <= 0:
					print("added")
					body.Destroyer = self
					body.ability()
