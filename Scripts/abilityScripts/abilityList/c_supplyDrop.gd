extends Contain
@onready var Random: Array = [
	"AppleCrate",
	"StinkyCheese",
	"DrinkPallete"
]
var rndSelected
var chosen
func _init() -> void:
	GivenName = "Medical Supply Drop"
	GivenWeight = 200
	GivenType = "Plastic"
	GivenIncome = 300
	GivenAbility = "Randomly Contains 4 Related Items or Boxes(Food or Medical)"
	GivenHealth = 500
	height = 2
	size = Vector3(2,2,2)
	canBeDestroyed = true
	

func randomized():
	for i in containerParent.get_children():
		rndSelected = Random.pick_random()
		chosen = "res://Nodes/itemNodes/z_" + rndSelected + ".tscn"
		spawn_without_preloading(chosen)


func spawn_without_preloading(scene_path: String) -> void:
	var loaded_scene = load(scene_path) as PackedScene
	
	if loaded_scene:
		var instance = loaded_scene.instantiate()
		
		add_child(instance)
		instance.global_position = Vector3.ZERO

		contain(instance)
		
		
	else:
		push_error("Failed to load scene at path: " + scene_path)
