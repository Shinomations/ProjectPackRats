extends Node3D
@export var items = [
	"WhoopAssCan"
]
@export var Contains = [
	"supplyDrop",
	"stackable"
]
@export var Tier1 = [
	"Nails",
	"Clothing",
	"SixShooter",
	"Ammo"
	#"Beehive" 
]
@export var Tier2 = [
	"Tungstin",
	"AppleCrate",
	"Cactus"
]
@export var Tier3 = [
	"Glassware",
	"Wire",
	"DoubleBarrel",
	"RelicBox",
	"PandoraBox"
]
@export var Tier4 = [
	"GasolineTank",
	"AWP",
	"IED",
	"StinkyCheese"
]
@export var Tier5 = [
	"anvil",
	"DrinkPallete",
	"MobsterCage"
]
var chosen
var player
var randomTier = randi_range(1,5)
@export var makeRandom: bool
@export var specificUnit: String
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var ArrayArray = [Contains,Contains,Contains,items,items,items,items,items,Tier1,Tier1,Tier1,Tier1,Tier1,Tier2,Tier2,Tier2,Tier2,Tier3,Tier3,Tier3,Tier4,Tier4,Tier5]
	var randomArray
	if makeRandom == true:
		randomArray = ArrayArray.pick_random()
		if randomArray == items:
			chosen = "res://Nodes/itemNodes/i_" + randomArray.pick_random() + ".tscn"
		elif randomArray == Contains:
			chosen = "res://Nodes/itemNodes/c_" + randomArray.pick_random() + ".tscn"
		else:
			print(randomArray)
			chosen = "res://Nodes/itemNodes/z_" + randomArray.pick_random() + ".tscn"
			print(chosen)
	else:
		chosen =  "res://Nodes/itemNodes/" + specificUnit + ".tscn"
	
	
	var myLocation = self.global_position 
	
	spawn_without_preloading(chosen, myLocation)

func spawn_without_preloading(scene_path: String, spawn_point: Vector3) -> void:
	var loaded_scene = load(scene_path) as PackedScene
	
	if loaded_scene:
		var instance = loaded_scene.instantiate()
		
		add_child(instance)
		
		instance.global_position = spawn_point
		
		
	else:
		push_error("Failed to load scene at path: " + scene_path)
