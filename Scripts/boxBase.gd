extends RigidBody3D

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $CollisionShape3D/MeshInstance3D

var selected = false
var player
var outlineWidth = 0.05

# Called when the node enters the scene tree for the first time.



func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.interact_object.connect(_set_selected)
	
	meshOutline.visible = false

func _process(_delta):
	
	#%CollisionShape3D.disabled = player == get_parent()
	meshOutline.visible = selected and not player == get_parent()
	
	if selected:
		boxbasic1.position.y = outlineWidth
		player.boxTypeDetector = 1 #change to set what 
	else:
		boxbasic1.position.y = 0

func _set_selected(object):
	selected = self == object
