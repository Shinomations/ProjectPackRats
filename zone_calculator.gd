extends Node3D

var boxType: int

@export var zone_scene: PackedScene

var PossibleBoxes: int
var zones2show: int

var zonesAlreadyFilled
var hasBoxInHand

var character
var BoxTypeSelected
func _ready() -> void:
	boxType = 0
	
	character = get_tree().get_first_node_in_group("player")
	
	
	zones2show = get_child_count()
	#zone2Use()
	#
func _process(_delta) -> void:
	
	if character.pickedObject != null:
	
		zone2Use()
		
	BoxTypeSelected = get_node("boxType" + str(boxType))
	PossibleBoxes = BoxTypeSelected.get_child_count()
	
	print(character.pickedObject)
	print(PossibleBoxes)
	

func zone2Use():
	while (boxType != character.boxTypeDetector):
		boxType += 1
		
	for marker in BoxTypeSelected.get_children():
		if marker.position.y == 0:
			var placement_zone = zone_scene.instantiate()
			
			marker.add_child(placement_zone)
			
