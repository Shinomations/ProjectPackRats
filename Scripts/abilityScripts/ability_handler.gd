extends Node3D

var abilityListTier1 = [
	"Nails",
	"Clothing",
	"SixShooter",
	"ammobox",
	"Beehive" 
]
var abilityListTier2 = [
	"Tungstin",
	"IED"
]
var abilityListTier3 = [
	"Glassware",
	"Wire",
	"DoubleBarrel"
]
var abilityListTier4 = [
	"GasolineTank",
	"AWP"
]
var abilityListTier5 = [
	"anvil",
	"DrinkPallete"
]
var chosen
var player
var randomTier = randi_range(1,5)
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var ArrayArray = [abilityListTier1,abilityListTier1,abilityListTier1,abilityListTier1,abilityListTier1,abilityListTier2,abilityListTier2,abilityListTier2,abilityListTier2,abilityListTier3,abilityListTier3,abilityListTier3,abilityListTier4,abilityListTier4,abilityListTier5]
	var randomArray = ArrayArray.pick_random()
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
