extends Node3D


# Called when the node enters the scene tree for the first time.
@onready var outline = $CollisionShape3D/MeshInstance3D

var GivenName = "Box With Anvils"
var GivenWeight = 500
var GivenType = "Wooden"
var GivenIncome = 1000
var GivenAbility = "First Placement: Destroy everything underneath this"

var scaling = 1.1

func _ready() -> void:
	
	print(GivenName)
	
func _process(delta: float) -> void:

	pass
