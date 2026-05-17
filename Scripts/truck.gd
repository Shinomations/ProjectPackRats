extends StaticBody3D

class_name store_object
const PROJECTILE_SCENE = preload("res://Nodes/itemNodes/placement_zone.tscn")
@onready var objects: Node3D = $Objects
@onready var object_places: Node3D = $ObjectPlaces

var itemsPlaced = []

func _ready() -> void:
	for i in object_places.get_child_count():
		itemsPlaced.append(null)
		self.set_collision_layer_value(1, false)
		
func add_object(object):
	if not itemsPlaced.has(null): return false
	
	object.reparent(objects)
	
	for i in len(itemsPlaced):
		if itemsPlaced[i]: continue
		self.set_collision_layer_value(1, true)
		object.global_position = object_places.get_children()[i].global_position
		itemsPlaced[i] = object
		object.rotation_degrees = Vector3(0,90,0)
		var new_obj = PROJECTILE_SCENE.instantiate()
		new_obj.position = object.position + Vector3(0,1.05,0)
		add_child(new_obj)
		break
		
	
	
func _on_objects_child_exiting_tree(node: Node) -> void:
	
	var index = itemsPlaced.find(node)
	
	itemsPlaced[index] = null
	
