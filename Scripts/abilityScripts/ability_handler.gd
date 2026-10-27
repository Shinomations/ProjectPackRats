extends Node3D
@export var Contains = {
	"supplyDrop": 50.0,
	"stackable": 50.0
}
@export var items = {
	"WhoopAssCan": 70.0,
	"mushroom": 30.0
}
@export var Tier1 = {
	"Nails": 25.0,
	"Clothing": 25.0,
	"SixShooter": 25.0,
	"Ammo": 25.0
}
@export var Tier2 = {
	"Tungstin": 25.0,
	"AppleCrate": 25.0,
	"Cactus": 25.0,
	"iceCube": 25.0
}
@export var Tier3 = {
	"Glassware": 20.0,
	"Wire": 20.0,
	"DoubleBarrel": 20.0,
	"RelicBox": 20.0,
	"PandoraBox": 20.0
}
@export var Tier4 = {
	"GasolineTank": 25.0,
	"AWP": 25.0,
	"IED": 25.0,
	"StinkyCheese": 25.0
}
@export var Tier5 = {
	"anvil": 70.0,
	"DrinkPallete": 25.0,
	"MobsterCage": 5.0
}
var chosen
var player
var randomTier = randi_range(1,5)
@export var makeRandom: bool
@export var specificUnit: String
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var ArrayArray = {
		Contains: 3.0,
		items: 5.0,
		Tier1: 5.0,
		Tier2: 4.0,
		Tier3: 3.0,
		Tier4: 2.0,
		Tier5: 1.0
	}
	var beginRolling = rolling(ArrayArray)
	
	if makeRandom == true:
		var randomArray = beginRolling.keys().pick_random()
		print(randomArray)
		if items.has(randomArray):
			chosen = "res://Nodes/itemNodes/i_" + randomArray + ".tscn"
		elif Contains.has(randomArray):
			chosen = "res://Nodes/itemNodes/c_" + randomArray + ".tscn"
		else:
			print(randomArray)
			chosen = "res://Nodes/itemNodes/z_" + randomArray + ".tscn"
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

func rolling(tops: Dictionary):
	var arrayTotal: int = 0
	for i in tops.values():
		arrayTotal += i
		
	var roll = randf() * arrayTotal
	var currentTotal = 0
	
	for i in tops.keys():
		currentTotal += tops[i]
		if roll <= currentTotal:
			return i
