extends Node3D

var abilityList = [
	"Anvils",
	"Books", 
	"Clothing",
	"Glassware",
	"Wire"
	]
var chosen
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	chosen = "res://Scripts/abilityScripts/abilityList/z_" + abilityList.pick_random() + ".gd"
	
	#player.Name = chosen
	
	self.set_script(load(chosen))
	if self.has_method("_init"):
		self._init()
		
	if self.has_method("_ready"):
		self._ready()
	
