extends Control

@onready var UnitName = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/NameLine
@onready var UnitWeight = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/WeightLine
@onready var UnitMaterial = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Material
@onready var UnitIncome = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Income
@onready var UnitAbility = $MarginContainer/VBoxContainer/Ability

@onready var player = get_parent()

func _ready() -> void:
	
	pass

func _process(_delta: float) -> void:
	
	if player and is_instance_valid(player.pickedObject):
		UnitName.text = player.Name
		UnitWeight.text = str(player.weight)
		UnitMaterial.text = player.material
		UnitIncome.text = str(player.Income)
		UnitAbility.text = player.ability
	else: 
		UnitName.text = "none"
		UnitWeight.text = str(0)
		UnitMaterial.text = "none"
		UnitIncome.text = str(0)
		UnitAbility.text = "none"
