extends StaticBody3D

class_name store_object
const PROJECTILE_SCENE = preload("res://Nodes/itemNodes/placement_zone.tscn")
@onready var objects: Node3D = $Objects
@onready var object_places: Node3D = $ObjectPlaces



func _ready() -> void:

	self.set_collision_layer_value(1, false)
		


func add_object(object):

	object.reparent(objects)
	

	self.set_collision_layer_value(1, true)
	object.global_position = object_places.get_children()[0].global_position

	object.rotation_degrees = Vector3(0,90,0)
	var new_obj = PROJECTILE_SCENE.instantiate()
	new_obj.name = "PlacementZone"
	new_obj.position = object.position + Vector3(0,1.05,0)
	add_child(new_obj, true)
	#print(itemsPlaced)
	

func isEmpty() -> bool:
	if objects.get_child_count() == 0: 
		
		return true
	
	return false;

func _on_objects_child_exiting_tree(_node: Node) -> void:
		
	
	self.set_collision_layer_value(1, false)
	#if is_instance_valid(find_child("PlacementZone")):
	#	self.find_child("PlacementZone").queue_free()
	
	#print(itemsPlaced)
