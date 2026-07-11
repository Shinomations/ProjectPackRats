extends Node3D

var abilityList = [
	"anvil",
	"books",
	"Clothing",
	"Glassware",
	"Wire",
	"Nails" 
]
var chosen
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	chosen = "res://Nodes/itemNodes/z_" + abilityList.pick_random() + ".tscn"
	print(chosen)
	
	var myLocation = self.global_position 
	
	spawn_without_preloading(chosen, myLocation)
	# REMOVED: queue_free() is gone so this randomizer stays in the scene

func spawn_without_preloading(scene_path: String, spawn_point: Vector3) -> void:
	var loaded_scene = load(scene_path) as PackedScene
	
	if loaded_scene:
		var instance = loaded_scene.instantiate()
		
		add_child(instance)
		
		instance.global_position = spawn_point
		
	else:
		push_error("Failed to load scene at path: " + scene_path)
