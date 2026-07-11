extends Control

@onready var UnitName = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/NameLine
@onready var UnitWeight = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/WeightLine
@onready var UnitMaterial = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Material
@onready var UnitIncome = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Income
@onready var UnitAbility = $MarginContainer/VBoxContainer/Ability
@onready var UnitHealth = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Health
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	# Backup check: If player group failed in _ready, try to find it now
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
	
	# The validation check
	if is_instance_valid(player) and is_instance_valid(player.pickedObject):
		UnitName.text = player.Name
		UnitWeight.text = str(player.weight)
		UnitMaterial.text = player.material
		UnitIncome.text = str(player.Income)
		UnitAbility.text = player.ability
		UnitHealth.text = str(player.health)
	else:
		if not is_instance_valid(player):
			pass
		elif not is_instance_valid(player.pickedObject):
			pass
		UnitName.text = "none"
		UnitWeight.text = str(0)
		UnitMaterial.text = "none"
		UnitIncome.text = str(0)
		UnitAbility.text = "none"
		UnitHealth.text = str(0)
