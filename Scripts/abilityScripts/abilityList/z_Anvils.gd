extends Area3D


# Called when the node enters the scene tree for the first time.

@onready var boxbasic1 = $CollisionShape3D
@onready var meshOutline = $CollisionShape3D/MeshInstance3D2

var GivenName = "Box With Anvils"
var GivenWeight = 500
var GivenType = "Wooden"
var GivenIncome = 1000
var GivenAbility = "First Placement: Destroy everything underneath this"

var scaling = 1.1

var selected = false
var player
var outlineWidth = 0.05

#ability specific variables
@onready var cast: Area3D = $"."


func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.interact_object.connect(_set_selected)
	
	meshOutline.visible = false

func _process(_delta):
	print()
	meshOutline.visible = selected and not player == get_parent()
	cast.body_entered.connect(_ability)
	if selected:
		boxbasic1.position.y = outlineWidth
		player.boxTypeDetector = 1 
	else:
		boxbasic1.position.y = 0
		
func _physics_process(delta: float) -> void:
	if cast.get_overlapping_bodies() == null:
		global_position.y -= gravity * delta
		
	pass


func _set_selected(object):
	selected = self == object
	

func _ability(body: Node3D) -> void:
	if body is CharacterBody3D and not player.pickedObject == self:
		body.queue_free()
		
