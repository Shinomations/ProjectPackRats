extends Node3D

var abilityList = [
	"res://Scripts/abilityScripts/abilityList/Anvils.gd",
	"res://Scripts/abilityScripts/abilityList/Books.gd", 
	"res://Scripts/abilityScripts/abilityList/Clothing.gd",
	"res://Scripts/abilityScripts/abilityList/Glassware.gd",
	"res://Scripts/abilityScripts/abilityList/Tech.gd"
	]
var chosen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chosen = abilityList.pick_random()
	#print(chosen)
	self.set_script(load(chosen))
	if self.has_method("_init"):
		self._init()
		
	if self.has_method("_ready"):
		self._ready()
	
