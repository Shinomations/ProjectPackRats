extends Node3D

@export var Tier1 = [
	"Nails",
	"Clothing",
	"SixShooter",
	"Ammo"
	#"Beehive" 
]
@export var Tier2 = [
	"Tungstin"
	#"IED"
]
@export var Tier3 = [
	"Glassware",
	"Wire",
	"DoubleBarrel"
]
@export var Tier4 = [
	"GasolineTank",
	"AWP"
]
@export var Tier5 = [
	"anvil",
	"DrinkPallete"
]
var chosen
var player
var randomTier = randi_range(1,5)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var ArrayArray = [Tier1,Tier1,Tier1,Tier1,Tier1,Tier2,Tier2,Tier2,Tier2,Tier3,Tier3,Tier3,Tier4,Tier4,Tier5]
	var randomArray = ArrayArray.pick_random()

	print(randomArray)
	chosen = "res://Nodes/itemNodes/z_" + randomArray.pick_random() + ".tscn"
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
