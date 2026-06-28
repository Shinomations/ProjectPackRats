extends CharacterBody3D

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $CollisionShape3D/MeshInstance3D

var selected = false
var player
var outlineWidth = 0.05

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
		

func _set_selected(object):
	selected = self == object
	

func _physics_process(delta):
	# Add the gravity to velocity each frame if not on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
	
func _ability():
	var i = 0
	var collision = get_slide_collision(0)
	
	move_and_slide()
	
	if get_slide_collision_count() > 0 and i > 0:
		print(collision.get_position())
	pass
