extends Node3D

var abilityList = [
	"Anvils",
	"Books", 
	"Clothing",
	"Glassware",
	"Tech"
	]
var chosen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	chosen = "res://Scripts/abilityScripts/abilityList/" + abilityList.pick_random() + ".gd"
	
	self.name = chosen
	
	self.set_script(load(chosen))
	if self.has_method("_init"):
		self._init()
		
	if self.has_method("_ready"):
		self._ready()
	
